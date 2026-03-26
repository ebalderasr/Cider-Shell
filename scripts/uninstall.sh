#!/usr/bin/env bash

set -euo pipefail

reset_key() {
  local schema="$1"
  local key="$2"

  if gsettings list-schemas | grep -qx "$schema"; then
    gsettings reset "$schema" "$key" || true
  fi
}

echo "Reverting Cider-Shell settings"

reset_key org.gnome.desktop.interface gtk-theme
reset_key org.gnome.desktop.interface icon-theme
reset_key org.gnome.desktop.interface cursor-theme
reset_key org.gnome.desktop.interface color-scheme
reset_key org.gnome.desktop.interface font-name
reset_key org.gnome.desktop.interface document-font-name
reset_key org.gnome.desktop.interface monospace-font-name
reset_key org.gnome.desktop.interface clock-show-weekday
reset_key org.gnome.desktop.interface clock-show-seconds
reset_key org.gnome.desktop.interface enable-hot-corners
reset_key org.gnome.desktop.interface show-battery-percentage
reset_key org.gnome.desktop.interface enable-animations
reset_key org.gnome.desktop.interface gtk-enable-primary-paste
reset_key org.gnome.desktop.background picture-uri
reset_key org.gnome.desktop.background picture-uri-dark
reset_key org.gnome.desktop.background picture-options
reset_key org.gnome.desktop.screensaver picture-uri
reset_key org.gnome.desktop.screensaver picture-options
reset_key org.gnome.desktop.peripherals.touchpad tap-to-click
reset_key org.gnome.desktop.peripherals.touchpad natural-scroll
reset_key org.gnome.desktop.peripherals.mouse natural-scroll
reset_key org.gnome.desktop.wm.preferences button-layout
reset_key org.gnome.desktop.wm.preferences titlebar-font
reset_key org.gnome.desktop.wm.preferences action-middle-click-titlebar
reset_key org.gnome.desktop.wm.preferences action-double-click-titlebar
reset_key org.gnome.desktop.wm.preferences action-right-click-titlebar
reset_key org.gnome.shell favorite-apps
reset_key org.gnome.nautilus.preferences show-delete-permanently
reset_key org.gnome.nautilus.preferences default-folder-viewer
reset_key org.gnome.mutter center-new-windows
reset_key org.gnome.mutter edge-tiling
reset_key org.gnome.settings-daemon.plugins.color night-light-enabled
reset_key org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type
reset_key org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type
reset_key org.gnome.shell.extensions.user-theme name

if gsettings list-schemas | grep -qx "org.gnome.shell.extensions.ubuntu-dock"; then
  reset_key org.gnome.shell.extensions.ubuntu-dock dock-position
  reset_key org.gnome.shell.extensions.ubuntu-dock extend-height
  reset_key org.gnome.shell.extensions.ubuntu-dock dash-max-icon-size
  reset_key org.gnome.shell.extensions.ubuntu-dock transparency-mode
  reset_key org.gnome.shell.extensions.ubuntu-dock autohide
  reset_key org.gnome.shell.extensions.ubuntu-dock intellihide
  reset_key org.gnome.shell.extensions.ubuntu-dock show-trash
  reset_key org.gnome.shell.extensions.ubuntu-dock show-mounts
fi

if gsettings list-schemas | grep -qx "org.gnome.shell.extensions.dash-to-dock"; then
  reset_key org.gnome.shell.extensions.dash-to-dock dock-position
  reset_key org.gnome.shell.extensions.dash-to-dock extend-height
  reset_key org.gnome.shell.extensions.dash-to-dock dash-max-icon-size
  reset_key org.gnome.shell.extensions.dash-to-dock transparency-mode
  reset_key org.gnome.shell.extensions.dash-to-dock autohide
  reset_key org.gnome.shell.extensions.dash-to-dock intellihide
  reset_key org.gnome.shell.extensions.dash-to-dock show-trash
  reset_key org.gnome.shell.extensions.dash-to-dock show-mounts
fi

echo "Cider-Shell settings reverted."
echo "This script does not remove packages, extensions, or theme files from disk."
