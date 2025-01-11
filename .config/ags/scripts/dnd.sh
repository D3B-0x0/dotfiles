#!/bin/bash

# File to track DND state
STATE_FILE="$HOME/.cache/ags/dnd_state"

if [ ! -f $STATE_FILE ]; then
    # If state file doesn't exist, create it and enable DND
    touch $STATE_FILE
    dbus-send --session --dest=org.freedesktop.Notifications \
              --type=method_call /org/freedesktop/Notifications \
              org.freedesktop.Notifications.Inhibit string:"DoNotDisturb"
    echo "Do Not Disturb Enabled"
else
    # If state file exists, remove it and disable DND
    rm $STATE_FILE
    dbus-send --session --dest=org.freedesktop.Notifications \
              --type=method_call /org/freedesktop/Notifications \
              org.freedesktop.Notifications.UnInhibit string:"DoNotDisturb"
    echo "Do Not Disturb Disabled"
fi
