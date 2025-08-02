#!/bin/bash

# Load centralized wallpaper configuration
CONFIG_FILE="$HOME/.wallpaper_config"
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo "❌ Config file not found: $CONFIG_FILE"
  exit 1
fi

# Ensure WALLPAPER_DIR is defined
if [[ -z "$WALLPAPER_DIR" ]]; then
  echo "❌ WALLPAPER_DIR is not defined in $CONFIG_FILE"
  exit 1
fi

# Find all supported image formats recursively
mapfile -t images < <(
  find "$WALLPAPER_DIR" -type f \( \
    -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o \
    -iname '*.bmp' -o -iname '*.webp' \)
)

# Handle case with no images
if [[ ${#images[@]} -eq 0 ]]; then
  echo "❌ No images found in $WALLPAPER_DIR"
  exit 1
fi

# Pick and apply a random wallpaper
random_image="${images[RANDOM % ${#images[@]}]}"
feh --bg-scale "$random_image"

echo "✅ Wallpaper set to: $random_image"
