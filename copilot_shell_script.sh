#!/usr/bin/bash
#create a copilot script that replaces the current name in config/config.env on the ASSIGNMENT value (row 2) 

# Check if config directory exists
if [ ! -d "config" ]; then
    echo "Error: config directory not found!"
    exit 1
fi

# Check if config.env file exists
if [ ! -f "config/config.env" ]; then
    echo "Error: config/config.env file not found!"
    exit 1
fi

#updating the ASSIGNMENT value in config/config.env on the ASSIGNMENT value (row 2) 
read -p "Enter the new name of the assignment" new_assignment

sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/"


#Verify the change was made
if grep -q "^ASSIGNMENT=\"$new_assignment\"$" config/config.env; then
    echo "Successfully updated assignment name to: $new_assignment"
else
    echo "Warning: Assignment name may not have been updated correctly."
    echo "Please check config/config.env manually."
fi

# Check if startup.sh exists and run it
if [ ! -f "startup.sh" ]; then
    echo "Error: startup.sh not found!"
    exit 1
fi

echo "Rerunning startup.sh to check non-submission status..."
./startup.sh

echo "Script completed successfully!"
