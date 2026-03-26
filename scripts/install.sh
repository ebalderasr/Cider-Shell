#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKDIR="$(mktemp -d)"

cleanup() {
  rm -rf "$WORKDIR"
}

trap cleanup EXIT

log() {
  printf '\n==> %s\n' "$1"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

apply_if_schema_exists() {
  local schema="$1"
  shift

  if gsettings list-schemas | grep -qx "$schema"; then
    while (($#)); do
      local key="$1"
      local value="$2"
      gsettings set "$schema" "$key" "$value"
      shift 2
    done
    return 0
  fi

  return 1
}

require_command sudo
require_command git
require_command gsettings

log "Installing required packages"
sudo apt update
sudo apt install -y \
  gnome-tweaks \
  gnome-shell-extension-manager \
  gnome-shell-extensions \
  git \
  sassc \
  libglib2.0-dev-bin \
  fonts-cantarell \
  fonts-noto-core

log "Cloning theme repositories"
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git "$WORKDIR/WhiteSur-gtk-theme" --depth=1
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git "$WORKDIR/WhiteSur-icon-theme" --depth=1
git clone https://github.com/vinceliuice/WhiteSur-cursors.git "$WORKDIR/WhiteSur-cursors" --depth=1

log "Installing WhiteSur GTK theme"
(cd "$WORKDIR/WhiteSur-gtk-theme" && ./install.sh -l -c light --shell -i ubuntu -m)

log "Installing WhiteSur icons"
(cd "$WORKDIR/WhiteSur-icon-theme" && ./install.sh)

log "Installing WhiteSur cursors"
(cd "$WORKDIR/WhiteSur-cursors" && ./install.sh)

log "Applying GNOME appearance settings"
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Light"
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"
gsettings set org.gnome.desktop.interface cursor-theme "WhiteSur-cursors"
gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
gsettings set org.gnome.desktop.interface font-name "Noto Sans 11"
gsettings set org.gnome.desktop.interface document-font-name "Noto Sans 11"
gsettings set org.gnome.desktop.interface monospace-font-name "Noto Sans Mono 12"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Noto Sans Bold 11"
gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"
gsettings set org.gnome.desktop.interface clock-show-weekday false
gsettings set org.gnome.desktop.interface clock-show-seconds false
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad click-method "fingers"
gsettings set org.gnome.desktop.peripherals.touchpad middle-click-emulation true
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.3
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true
gsettings set org.gnome.desktop.background picture-options "zoom"
gsettings set org.gnome.desktop.screensaver picture-options "zoom"
gsettings set org.gnome.nautilus.preferences show-delete-permanently true
gsettings set org.gnome.nautilus.preferences default-folder-viewer "list-view"
gsettings set org.gnome.shell favorite-apps "['firefox_firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Software.desktop', 'org.gnome.Settings.desktop']"
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4', '<Super>w']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>h', '<Super>m']"
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t', '<Super>t']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e', '<Super>n']"
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant "light"
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
gsettings set org.gnome.mutter auto-maximize false
gsettings set org.gnome.mutter focus-change-on-pointer-rest false

if gsettings list-schemas | grep -qx "org.gnome.shell.extensions.user-theme"; then
  gsettings set org.gnome.shell.extensions.user-theme name "WhiteSur-Light"
fi

if gsettings writable org.gnome.Terminal.ProfilesList default >/dev/null 2>&1; then
  DEFAULT_TERMINAL_PROFILE="$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')"
  TERMINAL_PROFILE_PATH="/org/gnome/terminal/legacy/profiles:/:${DEFAULT_TERMINAL_PROFILE}/"
  gsettings set "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" use-system-font false
  gsettings set "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" font "Noto Sans Mono 13"
  gsettings set "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" default-size-columns 96
  gsettings set "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" default-size-rows 28
  gsettings set "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" scrollbar-policy "never"
  gsettings set "org.gnome.Terminal.Legacy.Profile:${TERMINAL_PROFILE_PATH}" visible-name "Cider Light"
fi

log "Configuring dock"
if apply_if_schema_exists org.gnome.shell.extensions.ubuntu-dock \
  dock-position "'BOTTOM'" \
  extend-height "false" \
  dash-max-icon-size "56" \
  transparency-mode "'FIXED'" \
  autohide "true" \
  intellihide "true" \
  show-trash "false" \
  show-mounts "false"; then
  echo "Configured ubuntu-dock"
elif apply_if_schema_exists org.gnome.shell.extensions.dash-to-dock \
  dock-position "'BOTTOM'" \
  extend-height "false" \
  dash-max-icon-size "56" \
  transparency-mode "'FIXED'" \
  autohide "true" \
  intellihide "true" \
  show-trash "false" \
  show-mounts "false"; then
  echo "Configured dash-to-dock"
else
  echo "No supported dock schema detected. Skipping dock settings."
fi

if command -v bash >/dev/null 2>&1 && [ -x "$REPO_ROOT/scripts/post-install.sh" ]; then
  log "Applying post-install visual polish"
  bash "$REPO_ROOT/scripts/post-install.sh"
fi

if command -v bash >/dev/null 2>&1 && [ -x "$REPO_ROOT/scripts/apply-wallpaper.sh" ]; then
  log "Applying bundled wallpaper"
  bash "$REPO_ROOT/scripts/apply-wallpaper.sh" daybreak.svg
fi

cat <<EOF

Cider-Shell setup finished.

Next recommended steps:
1. Open Extension Manager / Administrador de extensiones
2. Install and enable: User Themes, Just Perfection, Blur my Shell
3. Follow: $REPO_ROOT/docs/extension-manager-guide.md
4. Run: $REPO_ROOT/scripts/post-install.sh
5. Run: $REPO_ROOT/scripts/check.sh
6. Log out and back in, or reboot

EOF
