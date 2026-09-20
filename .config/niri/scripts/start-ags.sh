#!/bin/bash
sleep 4
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
exec ags run /home/xandev/.config/ags/app.tsx
