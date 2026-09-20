#!/usr/bin/env bash

# Directory containing your wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Queue and position files
QUEUE_FILE="$HOME/.cache/wallpaper_queue.txt"
POSITION_FILE="$HOME/.cache/wallpaper_position.txt"

# Transition settings
TRANSITION="grow"
DURATION=2

# Matugen settings
MATUGEN_MODE="dark"
MATUGEN_SOURCE_INDEX=1

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    exit 1
fi

# Ensure cache directory exists
mkdir -p "$HOME/.cache"

# Function to generate shuffled queue
generate_queue() {
    find "$WALLPAPER_DIR" -type f \( \
        -iname "*.jpg" -o \
        -iname "*.jpeg" -o \
        -iname "*.png" -o \
        -iname "*.webp" -o \
        -iname "*.bmp" -o \
        -iname "*.tiff" \
    \) | shuf > "$QUEUE_FILE"
    echo "0" > "$POSITION_FILE"
}

# Check if queue exists and has content
if [ ! -s "$QUEUE_FILE" ]; then
    generate_queue
fi

# Read current position
if [ -f "$POSITION_FILE" ]; then
    POSITION=$(cat "$POSITION_FILE")
else
    POSITION=0
fi

# Get total number of wallpapers in queue
TOTAL=$(wc -l < "$QUEUE_FILE")

# Regenerate if needed
if [ "$TOTAL" -eq 0 ] || [ "$POSITION" -ge "$TOTAL" ]; then
    generate_queue
    POSITION=0
    TOTAL=$(wc -l < "$QUEUE_FILE")
fi

# Exit if still no wallpapers found
if [ "$TOTAL" -eq 0 ]; then
    exit 1
fi

# Get wallpaper at current position
WALLPAPER=$(sed -n "$((POSITION + 1))p" "$QUEUE_FILE")

# If wallpaper missing, regenerate queue
if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    generate_queue
    WALLPAPER=$(sed -n "1p" "$QUEUE_FILE")
    POSITION=0
fi

# Final guard
if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    exit 1
fi

# Ensure awww daemon is running
if ! awww query >/dev/null 2>&1; then
    awww-daemon >/dev/null 2>&1 &
    timeout=50
    counter=0
    until awww query >/dev/null 2>&1; do
        if [ "$counter" -ge "$timeout" ]; then
            exit 1
        fi
        sleep 0.1
        counter=$((counter + 1))
    done
fi

# Apply wallpaper
if ! awww img "$WALLPAPER" \
    --transition-type "$TRANSITION" \
    --transition-duration "$DURATION" \
    >/dev/null 2>&1; then
    exit 1
fi

# Increment position for next run
NEXT_POSITION=$((POSITION + 1))
if [ "$NEXT_POSITION" -ge "$TOTAL" ]; then
    NEXT_POSITION=$TOTAL
fi
echo "$NEXT_POSITION" > "$POSITION_FILE"

# Generate colors with matugen, non-interactive
if command -v matugen >/dev/null 2>&1; then
    matugen image "$WALLPAPER" -m "$MATUGEN_MODE" --source-color-index "$MATUGEN_SOURCE_INDEX" >/dev/null 2>&1
fi

if command -v ags >/dev/null 2>&1; then
    ags quit
    sleep 1
    nohup /usr/bin/ags run /home/xandev/.config/ags/app.tsx >/tmp/ags.log 2>&1 &
fi

exit 0
