#!/bin/sh

SOUNDPACK="/home/xandev/Software/nk-cream"

HEADSET=$(wpctl status | grep -i "cAVS Headphones")

# Kill only the wayvibes binary, not anything else
kill $(pgrep -x wayvibes) 2>/dev/null

sleep 0.5

if [ -n "$HEADSET" ]; then
  nohup wayvibes "$SOUNDPACK" -v 0.5 > /dev/null 2>&1 &
  notify-send -a "Wayvibes" "Wayvibes | Headset mode" "Working for headset"
else
  nohup wayvibes "$SOUNDPACK" -v 4 > /dev/null 2>&1 &
  notify-send -a "Wayvibes" "Wayvibes | Speaker mode" "Working for device speakers"
fi
