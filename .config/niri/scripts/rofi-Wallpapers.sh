#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

TRANSITION="random"
DURATION=2
FPS=145

MATUGEN_MODE="dark"
MATUGEN_SOURCE_INDEX=1

if [ ! -d "$WALLPAPER_DIR" ]; then
    exit 1
fi

selected="$(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
        -iname "*.jpg" -o \
        -iname "*.jpeg" -o \
        -iname "*.png" -o \
        -iname "*.webp" -o \
        -iname "*.bmp" -o \
        -iname "*.tiff" -o \
        -iname "*.gif" -o \
        -iname "*.avif" \
    \) -printf '%f\n' | sort | while IFS= read -r img; do
        printf '%s\0icon\x1fthumbnail://%s/%s\n' "$img" "$WALLPAPER_DIR" "$img"
    done | rofi -dmenu -show-icons -p "Wallpaper"
)"

[ -z "${selected:-}" ] && exit 0

WALLPAPER="$WALLPAPER_DIR/$selected"

if [ ! -f "$WALLPAPER" ]; then
    exit 1
fi

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

awww img "$WALLPAPER" \
    --transition-type "$TRANSITION" \
    --transition-duration "$DURATION" \
    --transition-fps "$FPS"\
    >/dev/null 2>&1

if command -v matugen >/dev/null 2>&1; then
    matugen image "$WALLPAPER" \
        -m "$MATUGEN_MODE" \
        --source-color-index "$MATUGEN_SOURCE_INDEX" \
        >/dev/null 2>&1
fi
if command -v ags >/dev/null 2>&1; then
    ags quit
    sleep 1
    nohup /usr/bin/ags run /home/xandev/.config/ags/app.tsx >/tmp/ags.log 2>&1 &
fi
