#!/bin/bash

WALLPAPER_DIR="$HOME/projects/aesthetic-wallpapers/images"

mapfile -t images < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \))

if [[ ${#images[@]} -eq 0 ]]; then
	echo "No images found in $WALLPAPER_DIR"
	exit 1
fi

random_image="${images[RANDOM % ${#images[@]}]}"

feh --bg-scale "$random_image"

echo "Wallpaper set to: $random_image"
