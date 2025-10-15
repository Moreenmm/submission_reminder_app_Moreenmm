#!/usr/bin/bash
#creates an app that reminds students about their pending submissions

#ask the user input and create a directory submission_reminder_{userinput}
read -p "enter your name: " yourname
mkdir -p submissions_reminder_$yourname

parent_dir="submissions_reminder_$yourname"
#create subdirectories
mkdir -p "$parent_dir/app"
mkdir -p "$parent_dir/modules"
mkdir -p "$parent_dir/assets"
mkdir -p "$parent_dir/config"

#create files in their respective subdirectories with the content inside them
#create config.env
echo "# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
" > "$parent_dir/config/config.env"

#create reminder.sh
echo "#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file

" > "$parent_dir/app/reminder.sh"

#create functions.sh
echo "#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}

" > "$parent_dir/modules/functions.sh"

#create submissions.txt
echo "student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Stacey, Git, submitted
Trina, Shell Permissions, not submitted
Muthoni, Shell Basics, not submitted
Fidel, Shell Processes, submitted
Asha, Git, submitted
" > "$parent_dir/assets/submissions.txt"

echo "
#!/usr/bin/bash
#create a script that runs the reminder app
if [ ! -f "$parent_dir/config/config.env" ]; then
	echo "Error! The config.env does not exist and cannot start the reminder app"
	exit 1
fi

./"$parent_dir/app/reminder.sh"

" > "$parent_dir/startup.sh"

# give execution permissions to the files ending with .sh

chmod +x "$parent_dir/app/reminder.sh"
chmod +x "$parent_dir/startup.sh"
chmod +x "$parent_dir/modules/functions.sh"

echo "Enter cd $parent_dir && ./startup.sh to start the app"





