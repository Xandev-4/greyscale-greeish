#!/bin/bash

action=$(printf " Lock\n󰍃 Logout\n Reboot\n Poweroff" | fuzzel --dmenu --minimal-lines --prompt "Power Menu: " --anchor top-right --x-margin 40 --y-margin 40 --font "monospace:size=8")

case $action in
  " Lock") hyprlock ;;  # change this if you use another locker
  "󰍃 Logout") niri msg action quit ;;
  " Reboot") systemctl reboot ;;
  " Poweroff") systemctl poweroff ;;
esac
