#!/usr/bin/bash
#create a copilot script that replaces the current name in config/config.env on the ASSIGNMENT value (row 2) 

#check for the app directory
read -p "Enter the name of the diectory: " yourname
main_dir="submission_reminder_$yourname"

if [ ! -d "$main_dir" ]; then
	echo "Error! The directory "$main_dir" does not exist"
	exit 1
fi

# Check if config directory exists
if [ ! -d "$main_dir/config" ]; then
    echo "Error! config directory not found!"
    exit 1
fi

# Check if config.env file exists
config_file="$main_dir/config/config.env"
if [ ! -f "$config_file" ]; then
    echo "Error! config/config.env file not found!"
    exit 1
fi

#updating the ASSIGNMENT value in config/config.env on the ASSIGNMENT value (row 2) 
read -p "Enter the new name of the assignment" new_assignment

sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"


#Verify the change was made
if grep -q "^ASSIGNMENT=\"$new_assignment\"$" $config_file"; then
    echo "Successfully updated assignment name to: $new_assignment"
else
    echo "Warning!! Assignment name may not have been updated correctly."
    echo "Please check config/config.env manually."
fi

# Check if startup.sh exists and run it
#startup_file="$main_dir/startup.sh"
if [ ! -f "$startup_file" ]; then
    echo "Error! startup.sh not found!"
    exit 1
fi

echo "Rerunning startup.sh to check non-submission status..."
./$startup_file

echo "Script completed successfully!"
