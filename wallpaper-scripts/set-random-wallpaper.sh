#!/bin/bash

# Load config
source "$HOME/.config/my-wallpapers/_load_config.sh"

# Read blacklist into array
mapfile -t BLACKLIST < <(sed '/^\s*#/d;/^\s*$/d' "$BLACKLIST_FILE" 2>/dev/null)

# Gather all images
mapfile -t all_images < <(find "$WALLPAPER_DIR" -type f \( \
  -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o \
  -iname '*.bmp' -o -iname '*.webp' \))

# Filter out blacklisted entries
images=()
for img in "${all_images[@]}"; do
  skip=false
  for blk in "${BLACKLIST[@]}"; do
    [[ "$img" == "$blk" ]] && skip=true && break
  done
  $skip || images+=("$img")
done

# Abort if no valid images
if [[ ${#images[@]} -eq 0 ]]; then
  echo "❌ No usable images found. (All are blacklisted?)"
  exit 1
fi

# Pick and set wallpaper
random_image="${images[RANDOM % ${#images[@]}]}"
feh --bg-scale "$random_image"

# Record for possible blacklisting
mkdir -p "$CONFIG_DIR"
echo "$random_image" > "$CURRENT_FILE"

echo "✅ Wallpaper set to: $random_image"
