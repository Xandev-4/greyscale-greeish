current=$(brightnessctl get)
min=960

if [ "$current" -le "$min" ]; then
  brightnessctl s $min
else
  brightnessctl s 5%-
fi
