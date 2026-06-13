#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

set_if_schema_exists_with_dir() {
  local schema_dir="$1"
  local schema="$2"
  local key="$3"
  local value="$4"

  if [ -d "$schema_dir" ] && gsettings --schemadir "$schema_dir" list-keys "$schema" 2>/dev/null | grep -Fx "$key" >/dev/null; then
    gsettings --schemadir "$schema_dir" set "$schema" "$key" "$value"
    return 0
  fi

  return 1
}

echo "Applying additional Cider-Shell polish"

set_if_key_exists org.gnome.desktop.interface gtk-enable-primary-paste false
set_if_key_exists org.gnome.desktop.interface locate-pointer false
set_if_key_exists org.gnome.desktop.interface accent-color "blue"
set_if_key_exists org.gnome.desktop.interface font-name "Inter 11"
set_if_key_exists org.gnome.desktop.interface document-font-name "Inter 11"
set_if_key_exists org.gnome.desktop.interface monospace-font-name "Noto Sans Mono 12"
set_if_key_exists org.gnome.desktop.calendar show-weekdate false
set_if_key_exists org.gnome.desktop.sound event-sounds false
set_if_key_exists org.gnome.desktop.wm.preferences action-middle-click-titlebar "none"
set_if_key_exists org.gnome.desktop.wm.preferences action-double-click-titlebar "toggle-maximize"
set_if_key_exists org.gnome.desktop.wm.preferences action-right-click-titlebar "menu"
set_if_key_exists org.gnome.desktop.wm.preferences titlebar-font "Inter Bold 11"
set_if_key_exists org.gnome.mutter center-new-windows true
set_if_key_exists org.gnome.mutter edge-tiling false
set_if_key_exists org.gnome.mutter auto-maximize false
set_if_key_exists org.gnome.mutter focus-change-on-pointer-rest false
set_if_key_exists org.gnome.settings-daemon.plugins.color night-light-enabled false
set_if_key_exists org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "nothing"
set_if_key_exists org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type "suspend"
set_if_key_exists org.gnome.desktop.peripherals.touchpad click-method "fingers"
set_if_key_exists org.gnome.desktop.peripherals.touchpad middle-click-emulation true
set_if_key_exists org.gnome.desktop.peripherals.touchpad speed 0.3
set_if_key_exists org.gnome.desktop.wm.keybindings close "['<Alt>F4', '<Super>w']"
set_if_key_exists org.gnome.desktop.wm.keybindings minimize "['<Super>h', '<Super>m']"
set_if_key_exists org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
set_if_key_exists org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
set_if_key_exists org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t', '<Super>t']"
set_if_key_exists org.gnome.settings-daemon.plugins.media-keys home "['<Super>e', '<Super>n']"
set_if_key_exists org.gnome.settings-daemon.plugins.media-keys search "['<Super>space']"
set_if_key_exists org.gnome.Terminal.Legacy.Settings theme-variant "light"
set_if_key_exists org.gnome.Terminal.Legacy.Settings default-show-menubar false
set_if_key_exists org.gnome.nautilus.preferences default-folder-viewer "list-view"
set_if_key_exists org.gnome.nautilus.preferences show-delete-permanently true
enable_shell_extension "user-theme@gnome-shell-extensions.gcampax.github.com"
enable_shell_extension "just-perfection-desktop@just-perfection"
enable_shell_extension "blur-my-shell@aunetx"
set_if_key_exists org.gnome.shell.extensions.user-theme name "WhiteSur-Light"

configure_gnome_terminal
configure_ptyxis

JUST_PERFECTION_SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/just-perfection-desktop@just-perfection/schemas"
if set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection activities-button false; then
  set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection clock-menu-position 0
  set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection panel-size 32
  set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection show-apps-button false
  set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection window-picker-icon false
  set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection workspace-popup false
  set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection accessibility-menu false
  set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection power-icon false
  set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection startup-status 0
  set_if_schema_exists_with_dir "$JUST_PERFECTION_SCHEMA_DIR" org.gnome.shell.extensions.just-perfection notification-banner-position 2
  echo "Just Perfection detected and configured"
else
  echo "Just Perfection not detected. Skipping extension-specific settings."
fi

BLUR_SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas"
if set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.panel blur true; then
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.panel brightness 0.7
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.panel sigma 20
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.panel static-blur true
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.panel style-panel 0
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.panel override-background true
  echo "Blur my Shell panel settings applied"
else
  echo "Blur my Shell panel schema not detected. Skipping blur settings."
fi

if set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true; then
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.7
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.dash-to-dock corner-radius 18
  echo "Blur my Shell dock settings applied"
fi

if set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.overview blur true; then
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.overview brightness 0.6
  set_if_schema_exists_with_dir "$BLUR_SCHEMA_DIR" org.gnome.shell.extensions.blur-my-shell.overview sigma 30
  echo "Blur my Shell overview settings applied"
fi
