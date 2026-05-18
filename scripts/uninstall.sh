#!/usr/bin/env bash

set -euo pipefail

reset_key() {
  local schema="$1"
  local key="$2"

  if gsettings list-keys "$schema" 2>/dev/null | grep -Fx "$key" >/dev/null; then
    gsettings reset "$schema" "$key" || true
  fi
}

remove_file() {
  local path="$1"

  if [ -f "$path" ] && grep -qx "X-Cider-Shell=true" "$path"; then
    rm -f "$path"
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
reset_key org.gnome.desktop.interface locate-pointer
reset_key org.gnome.desktop.background picture-uri
reset_key org.gnome.desktop.background picture-uri-dark
reset_key org.gnome.desktop.background picture-options
reset_key org.gnome.desktop.screensaver picture-uri
reset_key org.gnome.desktop.screensaver picture-options
reset_key org.gnome.desktop.peripherals.touchpad tap-to-click
reset_key org.gnome.desktop.peripherals.touchpad natural-scroll
reset_key org.gnome.desktop.peripherals.touchpad click-method
reset_key org.gnome.desktop.peripherals.touchpad middle-click-emulation
reset_key org.gnome.desktop.peripherals.touchpad speed
reset_key org.gnome.desktop.peripherals.mouse natural-scroll
reset_key org.gnome.desktop.calendar show-weekdate
reset_key org.gnome.desktop.sound event-sounds
reset_key org.gnome.desktop.wm.preferences button-layout
reset_key org.gnome.desktop.wm.preferences titlebar-font
reset_key org.gnome.desktop.wm.preferences action-middle-click-titlebar
reset_key org.gnome.desktop.wm.preferences action-double-click-titlebar
reset_key org.gnome.desktop.wm.preferences action-right-click-titlebar
reset_key org.gnome.desktop.wm.keybindings close
reset_key org.gnome.desktop.wm.keybindings minimize
reset_key org.gnome.settings-daemon.plugins.media-keys terminal
reset_key org.gnome.settings-daemon.plugins.media-keys home
reset_key org.gnome.shell favorite-apps
reset_key org.gnome.nautilus.preferences show-delete-permanently
reset_key org.gnome.nautilus.preferences default-folder-viewer
reset_key org.gnome.mutter center-new-windows
reset_key org.gnome.mutter edge-tiling
reset_key org.gnome.mutter auto-maximize
reset_key org.gnome.mutter focus-change-on-pointer-rest
reset_key org.gnome.settings-daemon.plugins.color night-light-enabled
reset_key org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type
reset_key org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type
reset_key org.gnome.Terminal.Legacy.Settings theme-variant
reset_key org.gnome.Terminal.Legacy.Settings default-show-menubar
reset_key org.gnome.shell.extensions.user-theme name
reset_key org.gnome.Ptyxis interface-style
reset_key org.gnome.Ptyxis use-system-font
reset_key org.gnome.Ptyxis font-name
reset_key org.gnome.Ptyxis default-columns
reset_key org.gnome.Ptyxis default-rows
reset_key org.gnome.Ptyxis restore-window-size
reset_key org.gnome.Ptyxis scrollbar-policy
reset_key org.gnome.Ptyxis audible-bell
reset_key org.gnome.Ptyxis visual-bell
reset_key org.gnome.Ptyxis cursor-shape

if gsettings writable org.gnome.Terminal.ProfilesList default >/dev/null 2>&1; then
  DEFAULT_TERMINAL_PROFILE="$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')"
  TERMINAL_PROFILE_PATH="/org/gnome/terminal/legacy/profiles:/:${DEFAULT_TERMINAL_PROFILE}/"
  reset_key "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" use-system-font
  reset_key "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" font
  reset_key "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" default-size-columns
  reset_key "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" default-size-rows
  reset_key "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" scrollbar-policy
  reset_key "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" visible-name
fi

if gsettings list-schemas | grep -Fx "org.gnome.Ptyxis" >/dev/null; then
  PTYXIS_PROFILE_UUID="$(gsettings get org.gnome.Ptyxis default-profile-uuid 2>/dev/null | tr -d \')"
  if [ -n "$PTYXIS_PROFILE_UUID" ]; then
    PTYXIS_PROFILE_PATH="/org/gnome/Ptyxis/Profiles/${PTYXIS_PROFILE_UUID}/"
    reset_key "org.gnome.Ptyxis.Profile:${PTYXIS_PROFILE_PATH}" opacity
    reset_key "org.gnome.Ptyxis.Profile:${PTYXIS_PROFILE_PATH}" palette
    reset_key "org.gnome.Ptyxis.Profile:${PTYXIS_PROFILE_PATH}" label
    reset_key "org.gnome.Ptyxis.Profile:${PTYXIS_PROFILE_PATH}" scrollback-lines
  fi
fi

if gsettings list-schemas | grep -Fx "org.gnome.shell.extensions.ubuntu-dock" >/dev/null; then
  reset_key org.gnome.shell.extensions.ubuntu-dock dock-position
  reset_key org.gnome.shell.extensions.ubuntu-dock extend-height
  reset_key org.gnome.shell.extensions.ubuntu-dock dash-max-icon-size
  reset_key org.gnome.shell.extensions.ubuntu-dock transparency-mode
  reset_key org.gnome.shell.extensions.ubuntu-dock autohide
  reset_key org.gnome.shell.extensions.ubuntu-dock intellihide
  reset_key org.gnome.shell.extensions.ubuntu-dock show-trash
  reset_key org.gnome.shell.extensions.ubuntu-dock show-mounts
fi

if gsettings list-schemas | grep -Fx "org.gnome.shell.extensions.dash-to-dock" >/dev/null; then
  reset_key org.gnome.shell.extensions.dash-to-dock dock-position
  reset_key org.gnome.shell.extensions.dash-to-dock extend-height
  reset_key org.gnome.shell.extensions.dash-to-dock dash-max-icon-size
  reset_key org.gnome.shell.extensions.dash-to-dock transparency-mode
  reset_key org.gnome.shell.extensions.dash-to-dock autohide
  reset_key org.gnome.shell.extensions.dash-to-dock intellihide
  reset_key org.gnome.shell.extensions.dash-to-dock show-trash
  reset_key org.gnome.shell.extensions.dash-to-dock show-mounts
fi

remove_file "$HOME/.local/share/applications/google-chrome.desktop"
remove_file "$HOME/.local/share/applications/com.google.Chrome.desktop"
remove_file "$HOME/.local/share/applications/brave-browser.desktop"
remove_file "$HOME/.local/share/applications/com.brave.Browser.desktop"

echo "Cider-Shell settings reverted."
echo "This script does not remove packages, extensions, or theme files from disk."
