#!/usr/bin/bash
#create a copilot script that replaces the current name in config/config.env on the ASSIGNMENT value (row 2) 

#check if the file config/config.env exists
read -p "Enter the name of the directory you created: " yourname
main_dir="submission_reminder_$yourname"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_DIR="$SCRIPT_DIR/$main_dir"
echo "$APP_DIR"
cd $APP_DIR

if [[ ! -d "$APP_DIR" ]]; then
    echo "Error: The app's main directory does not exist"
    exit 1
fi

if [  ! -f "$APP_DIR/config/config.env"  ];then
        echo "Error!file does not exist"
        exit 1
fi

#updating the ASSIGNMENT value in config/config.env on the ASSIGNMENT value (row 2) 
read -p "Enter the new name of the assignment: " new_assignment

if [[ -z "$new_assignment" ]]; then
    echo "Error: New assignment name cannot be empty"
    exit 1
fi

#replacing with the new name in config/config.env on row two
escaped_assignment=$(printf '%s\n' "$assignment" | sed 's/[\/&]/\\&/g')

sed -i "s/ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" config/config.env

echo "Assignment updated successfully to: $new_assignment"

# Check if startup.sh exists and run it
startup_file="$main_dir/startup.sh"
if [ ! -f startup.sh ]; then
    echo "Error! startup.sh not found and cannot be rerun the app"
    exit 1
fi

echo "Rerunning startup.sh to check non-submission status..."
./startup.sh 

echo "Script completed successfully!"
