#!/usr/bin/env bash

set -euo pipefail

set_if_schema_exists() {
  local schema="$1"
  local key="$2"
  local value="$3"

  if gsettings list-schemas | grep -qx "$schema"; then
    gsettings set "$schema" "$key" "$value"
  fi
}

echo "Applying additional Cider-Shell polish"

set_if_schema_exists org.gnome.desktop.interface gtk-enable-primary-paste false
set_if_schema_exists org.gnome.desktop.interface locate-pointer false
set_if_schema_exists org.gnome.desktop.calendar show-weekdate false
set_if_schema_exists org.gnome.desktop.sound event-sounds false
set_if_schema_exists org.gnome.desktop.wm.preferences action-middle-click-titlebar "none"
set_if_schema_exists org.gnome.desktop.wm.preferences action-double-click-titlebar "toggle-maximize"
set_if_schema_exists org.gnome.desktop.wm.preferences action-right-click-titlebar "menu"
set_if_schema_exists org.gnome.mutter center-new-windows true
set_if_schema_exists org.gnome.mutter edge-tiling false
set_if_schema_exists org.gnome.settings-daemon.plugins.color night-light-enabled false
set_if_schema_exists org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "nothing"
set_if_schema_exists org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type "suspend"
set_if_schema_exists org.gnome.shell.extensions.user-theme name "WhiteSur-Light"

if gsettings list-schemas | grep -qx "org.gnome.shell.extensions.just-perfection"; then
  set_if_schema_exists org.gnome.shell.extensions.just-perfection activities-button false
  set_if_schema_exists org.gnome.shell.extensions.just-perfection app-menu false
  set_if_schema_exists org.gnome.shell.extensions.just-perfection clock-menu-position 1
  set_if_schema_exists org.gnome.shell.extensions.just-perfection panel-size 32
  set_if_schema_exists org.gnome.shell.extensions.just-perfection show-apps-button false
  set_if_schema_exists org.gnome.shell.extensions.just-perfection window-picker-icon false
  set_if_schema_exists org.gnome.shell.extensions.just-perfection workspace-popup false
  echo "Just Perfection detected and configured"
else
  echo "Just Perfection not detected. Skipping extension-specific settings."
fi

if gsettings list-schemas | grep -qx "org.gnome.shell.extensions.blur-my-shell.panel"; then
  set_if_schema_exists org.gnome.shell.extensions.blur-my-shell.panel blur true
  set_if_schema_exists org.gnome.shell.extensions.blur-my-shell.panel brightness 0.6
  set_if_schema_exists org.gnome.shell.extensions.blur-my-shell.panel sigma 30
  set_if_schema_exists org.gnome.shell.extensions.blur-my-shell.panel static-blur true
  echo "Blur my Shell panel settings applied"
else
  echo "Blur my Shell panel schema not detected. Skipping blur settings."
fi

if gsettings list-schemas | grep -qx "org.gnome.shell.extensions.blur-my-shell.dash-to-dock"; then
  set_if_schema_exists org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
  set_if_schema_exists org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
  set_if_schema_exists org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
  set_if_schema_exists org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
  echo "Blur my Shell dock settings applied"
fi
