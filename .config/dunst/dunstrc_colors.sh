#!/bin/bash

# Source Pywal colors
source ~/.cache/wal/colors.sh

# Debug: Print colors to ensure they are set
echo "Background: $background"
echo "Foreground: $foreground"
echo "Color1: $color1"
echo "Color2: $color2"
echo "Color3: $color3"

# Update Dunst config with quoted colors
sed -i "s/background = .*/background = \"$background\"/g" ~/.config/dunst/dunstrc
sed -i "s/foreground = .*/foreground = \"$foreground\"/g" ~/.config/dunst/dunstrc

# Update frame colors per urgency level
sed -i "/\[urgency_low\]/,/^\[/ s/frame_color = .*/frame_color = \"$color1\"/" ~/.config/dunst/dunstrc
sed -i "/\[urgency_normal\]/,/^\[/ s/frame_color = .*/frame_color = \"$color2\"/" ~/.config/dunst/dunstrc
sed -i "/\[urgency_critical\]/,/^\[/ s/frame_color = .*/frame_color = \"$color3\"/" ~/.config/dunst/dunstrc

# Restart Dunst to apply changes
pkill dunst && dunst &


