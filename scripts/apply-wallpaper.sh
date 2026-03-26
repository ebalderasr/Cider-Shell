#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALLPAPER_DIR="$REPO_ROOT/assets/wallpapers"

usage() {
  cat <<EOF
Usage:
  ./scripts/apply-wallpaper.sh
  ./scripts/apply-wallpaper.sh <filename>
  ./scripts/apply-wallpaper.sh <absolute-path>
  ./scripts/apply-wallpaper.sh --list

Examples:
  ./scripts/apply-wallpaper.sh
  ./scripts/apply-wallpaper.sh daybreak.svg
  ./scripts/apply-wallpaper.sh /home/user/Pictures/wallpaper.jpg
EOF
}

set_wallpaper() {
  local path="$1"
  local uri="file://$path"

  gsettings set org.gnome.desktop.background picture-uri "$uri"
  gsettings set org.gnome.desktop.background picture-uri-dark "$uri"
  gsettings set org.gnome.desktop.background picture-options "zoom"
  gsettings set org.gnome.desktop.screensaver picture-uri "$uri"
  gsettings set org.gnome.desktop.screensaver picture-options "zoom"
}

if [ "${1:-}" = "--list" ]; then
  find "$WALLPAPER_DIR" -maxdepth 1 -type f | sort
  exit 0
fi

TARGET="${1:-daybreak.svg}"

if [[ "$TARGET" = /* ]]; then
  WALLPAPER_PATH="$TARGET"
else
  WALLPAPER_PATH="$WALLPAPER_DIR/$TARGET"
fi

if [ ! -f "$WALLPAPER_PATH" ]; then
  echo "Wallpaper not found: $WALLPAPER_PATH" >&2
  usage
  exit 1
fi

set_wallpaper "$(realpath "$WALLPAPER_PATH")"
echo "Applied wallpaper: $WALLPAPER_PATH"
