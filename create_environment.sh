#!/usr/bin/bash
#creates an app that reminds students about their pending submissions

#ask the user input and create a directory submission_reminder_{userinput}
read -p "enter your name: " yourname
mkdir -p submission_reminder_$yourname

main_dir="submission_reminder_$yourname"
#create subdirectories
mkdir -p "$main_dir/app"
mkdir -p "$main_dir/modules"
mkdir -p "$main_dir/assets"
mkdir -p "$main_dir/config"

#create files in their respective subdirectories with the content inside them
#create config.env
cat > "$main_dir/config/config.env" <<EOL
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

#create reminder.sh
cat > "$main_dir/app/reminder.sh" <<'EOL'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
EOL

#create functions.sh
cat > "$main_dir/modules/functions.sh" <<'EOL'
#!/bin/bash

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
EOL

#create submissions.txt
cat > "$main_dir/assets/submissions.txt" <<EOL
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Stacey, Git, submitted
Trina, Shell Basics, not submitted
Muthoni, Shell Navigation, not submitted
Fidel, Shell Navigation, submitted
Asha, Git, submitted
EOL


#create a startup script named startup.sh
cat > "$main_dir/startup.sh" <<'EOL'
#!/usr/bin/bash
# create a script that runs the reminder app

if [ ! -f "config/config.env" ]; then
    echo "Error! The config.env does not exist and cannot start the reminder app"
    exit 1
fi

./app/reminder.sh
EOL

# give execution permissions to the files ending with .sh

chmod +x "$main_dir/app/reminder.sh"
chmod +x "$main_dir/startup.sh"
chmod +x "$main_dir/modules/functions.sh"

echo "Environment setup complete!"
echo "To run the app: cd $main_dir && ./startup.sh"

