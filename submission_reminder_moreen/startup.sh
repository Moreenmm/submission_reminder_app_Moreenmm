#!/usr/bin/bash
# create a script that runs the reminder app

if [ ! -f "config/config.env" ]; then
    echo "Error! The config.env does not exist and cannot start the reminder app"
    exit 1
fi

./app/reminder.sh
