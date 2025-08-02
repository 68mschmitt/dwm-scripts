#!/bin/bash

git config set advice.defaultBranchName false

# Load config
CONFIG_FILE="$HOME/.wallpaper_config"
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo "❌ Config file not found: $CONFIG_FILE"
  exit 1
fi

# Create the main wallpaper directory if missing
mkdir -p "$WALLPAPER_DIR"

# Loop through each repo entry
for entry in "${REPO_SOURCES[@]}"; do
  if [[ "$entry" == *"::"* ]]; then
    # Sparse checkout
    REPO_URL="${entry%%::*}"
    SPARSE_DIR="${entry##*::}"
    IS_SPARSE=true
  else
    # Full clone
    REPO_URL="$entry"
    SPARSE_DIR=""
    IS_SPARSE=false
  fi

  REPO_NAME=$(basename -s .git "$REPO_URL")
  TARGET_DIR="$WALLPAPER_DIR/$REPO_NAME"

  echo "📥 Cloning: $REPO_URL"
  [[ $IS_SPARSE == true ]] && echo "🧃 Sparse path: $SPARSE_DIR"
  echo "📁 Destination: $TARGET_DIR"

  if [[ -d "$TARGET_DIR/.git" ]]; then
    echo "🔄 Updating existing repo..."
    cd "$TARGET_DIR" || continue
    git pull origin main
    continue
  fi

  mkdir -p "$TARGET_DIR"
  cd "$TARGET_DIR" || exit 1
  git init
  git remote add origin "$REPO_URL"

  if [[ $IS_SPARSE == true ]]; then
    git config core.sparseCheckout true
    echo "$SPARSE_DIR/" >> .git/info/sparse-checkout
  fi

  git pull origin main

  echo "✅ Cloned $REPO_URL"
  echo
done
