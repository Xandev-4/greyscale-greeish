#!/bin/bash

# Check if Waybar is running
if pgrep -x waybar > /dev/null; then
  # Send reload signal
  pkill -SIGUSR1 waybar
else
  # Start Waybar in background
  nohup waybar >/dev/null 2>&1 &
fi
