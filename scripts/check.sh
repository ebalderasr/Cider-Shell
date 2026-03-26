#!/usr/bin/env bash

set -euo pipefail

check_value() {
  local label="$1"
  local schema="$2"
  local key="$3"
  local expected="$4"
  local actual

  actual="$(gsettings get "$schema" "$key" 2>/dev/null || true)"
  if [ "$actual" = "$expected" ]; then
    printf '[OK] %s -> %s\n' "$label" "$actual"
  else
    printf '[WARN] %s -> expected %s but found %s\n' "$label" "$expected" "${actual:-<unavailable>}"
  fi
}

echo "Cider-Shell configuration check"
echo

check_value "GTK theme" org.gnome.desktop.interface gtk-theme "'WhiteSur-Light'"
check_value "Icon theme" org.gnome.desktop.interface icon-theme "'WhiteSur'"
check_value "Cursor theme" org.gnome.desktop.interface cursor-theme "'WhiteSur-cursors'"
check_value "Color scheme" org.gnome.desktop.interface color-scheme "'prefer-light'"
check_value "Window buttons" org.gnome.desktop.wm.preferences button-layout "'close,minimize,maximize:'"
check_value "Top bar seconds" org.gnome.desktop.interface clock-show-seconds "false"
check_value "Hot corners" org.gnome.desktop.interface enable-hot-corners "false"
check_value "Battery percentage" org.gnome.desktop.interface show-battery-percentage "true"

if gsettings list-schemas | grep -qx "org.gnome.shell.extensions.user-theme"; then
  check_value "Shell theme" org.gnome.shell.extensions.user-theme name "'WhiteSur-Light'"
else
  echo "[INFO] User Themes schema not found"
fi

if gsettings list-schemas | grep -qx "org.gnome.shell.extensions.ubuntu-dock"; then
  check_value "Dock position" org.gnome.shell.extensions.ubuntu-dock dock-position "'BOTTOM'"
  check_value "Dock auto-hide" org.gnome.shell.extensions.ubuntu-dock autohide "true"
  check_value "Dock panel mode" org.gnome.shell.extensions.ubuntu-dock extend-height "false"
elif gsettings list-schemas | grep -qx "org.gnome.shell.extensions.dash-to-dock"; then
  check_value "Dock position" org.gnome.shell.extensions.dash-to-dock dock-position "'BOTTOM'"
  check_value "Dock auto-hide" org.gnome.shell.extensions.dash-to-dock autohide "true"
  check_value "Dock panel mode" org.gnome.shell.extensions.dash-to-dock extend-height "false"
else
  echo "[INFO] No supported dock schema found"
fi

echo
echo "Manual checks still recommended:"
echo "- Confirm User Themes, Just Perfection, and Blur my Shell are installed and enabled"
echo "- Confirm the shell theme is set in Tweaks / Retoques"
echo "- Reboot or log out if a theme did not apply immediately"
