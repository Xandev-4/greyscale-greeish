#!/bin/bash

MIN_PERCENT=5
STEP=5

case "$1" in
    "up")
        brightnessctl s +"$STEP"%
        ;;
    "down")
        # Get current percentage (extract number from output like "50%")
        CURRENT=$(brightnessctl | grep -oE '\([0-9]+%\)' | tr -d '()%')
        
        # Calculate what new brightness would be
        NEW=$((CURRENT - STEP))
        
        # If new brightness would be below minimum, set to minimum
        if [ "$NEW" -lt "$MIN_PERCENT" ]; then
            brightnessctl s "$MIN_PERCENT"%
        else
            brightnessctl s "$STEP"%-
        fi
        ;;
esac

# Show SwayOSD popup with current brightness
BRIGHTNESS=$(brightnessctl | grep -oE '\([0-9]+%\)' | tr -d '()%')
swayosd-client --brightness "$BRIGHTNESS"
