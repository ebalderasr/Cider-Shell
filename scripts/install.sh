#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKDIR="$(mktemp -d)"

source "$REPO_ROOT/scripts/lib.sh"

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

  if gsettings list-schemas | grep -Fx "$schema" >/dev/null; then
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

install_gnome_extension() {
  local uuid="$1"
  local version_tag="$2"
  local label="$3"
  local zip_file="$WORKDIR/${uuid}.zip"

  if [ -d "$HOME/.local/share/gnome-shell/extensions/$uuid" ] || [ -d "/usr/share/gnome-shell/extensions/$uuid" ]; then
    echo "$label is already installed"
    return 0
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to download $label" >&2
    return 1
  fi

  if ! command -v gnome-extensions >/dev/null 2>&1; then
    echo "gnome-extensions is required to install $label" >&2
    return 1
  fi

  echo "Installing $label"
  curl -fsSL \
    -o "$zip_file" \
    "https://extensions.gnome.org/download-extension/${uuid}.shell-extension.zip?version_tag=${version_tag}"
  gnome-extensions install --force "$zip_file"
}

install_chromium_titlebar_override() {
  local desktop_id="$1"
  local binary="$2"
  local icon="$3"
  local name="$4"
  local mime="$5"
  local target_dir="$HOME/.local/share/applications"
  local target_file="$target_dir/${desktop_id}.desktop"
  local no_display_line=""

  if [ ! -x "$binary" ]; then
    echo "Skipping $name launcher override. Binary not found: $binary"
    return 0
  fi

  mkdir -p "$target_dir"

  if [[ "$desktop_id" == com.* ]]; then
    no_display_line="NoDisplay=true"
  fi

  cat >"$target_file" <<EOF
[Desktop Entry]
Version=1.0
Name=$name
GenericName=Web Browser
Comment=Access the Internet
Exec=$binary --ozone-platform=x11 %U
StartupNotify=true
Terminal=false
Icon=$icon
Type=Application
Categories=Network;WebBrowser;
MimeType=$mime
Actions=new-window;new-private-window;
X-Cider-Shell=true
$no_display_line

[Desktop Action new-window]
Name=New Window
Exec=$binary --ozone-platform=x11

[Desktop Action new-private-window]
Name=New Incognito Window
Exec=$binary --ozone-platform=x11 --incognito
EOF
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
  curl \
  git \
  sassc \
  libglib2.0-dev-bin \
  fonts-inter \
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

log "Installing GNOME shell extensions"
install_gnome_extension "just-perfection-desktop@just-perfection" "68110" "Just Perfection"
install_gnome_extension "blur-my-shell@aunetx" "69740" "Blur my Shell"

log "Applying GNOME appearance settings"
set_if_key_exists org.gnome.desktop.interface gtk-theme "WhiteSur-Light"
set_if_key_exists org.gnome.desktop.interface icon-theme "WhiteSur"
set_if_key_exists org.gnome.desktop.interface cursor-theme "WhiteSur-cursors"
set_if_key_exists org.gnome.desktop.interface color-scheme "prefer-light"
set_if_key_exists org.gnome.desktop.interface accent-color "blue"
set_if_key_exists org.gnome.desktop.interface font-name "Inter 11"
set_if_key_exists org.gnome.desktop.interface document-font-name "Inter 11"
set_if_key_exists org.gnome.desktop.interface monospace-font-name "Noto Sans Mono 12"
set_if_key_exists org.gnome.desktop.wm.preferences titlebar-font "Inter Bold 11"
set_if_key_exists org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"
set_if_key_exists org.gnome.desktop.interface clock-show-weekday false
set_if_key_exists org.gnome.desktop.interface clock-show-seconds false
set_if_key_exists org.gnome.desktop.interface enable-hot-corners false
set_if_key_exists org.gnome.desktop.interface show-battery-percentage true
set_if_key_exists org.gnome.desktop.interface enable-animations true
set_if_key_exists org.gnome.desktop.peripherals.touchpad tap-to-click true
set_if_key_exists org.gnome.desktop.peripherals.touchpad natural-scroll true
set_if_key_exists org.gnome.desktop.peripherals.touchpad click-method "fingers"
set_if_key_exists org.gnome.desktop.peripherals.touchpad middle-click-emulation true
set_if_key_exists org.gnome.desktop.peripherals.touchpad speed 0.3
set_if_key_exists org.gnome.desktop.peripherals.mouse natural-scroll false
set_if_key_exists org.gnome.desktop.background picture-options "zoom"
set_if_key_exists org.gnome.desktop.screensaver picture-options "zoom"
set_if_key_exists org.gnome.nautilus.preferences show-delete-permanently true
set_if_key_exists org.gnome.nautilus.preferences default-folder-viewer "list-view"
set_if_key_exists org.gnome.desktop.wm.keybindings close "['<Alt>F4', '<Super>w']"
set_if_key_exists org.gnome.desktop.wm.keybindings minimize "['<Super>h', '<Super>m']"
set_if_key_exists org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
set_if_key_exists org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
set_if_key_exists org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t', '<Super>t']"
set_if_key_exists org.gnome.settings-daemon.plugins.media-keys home "['<Super>e', '<Super>n']"
set_if_key_exists org.gnome.settings-daemon.plugins.media-keys search "['<Super>space']"
set_if_key_exists org.gnome.Terminal.Legacy.Settings theme-variant "light"
set_if_key_exists org.gnome.Terminal.Legacy.Settings default-show-menubar false
set_if_key_exists org.gnome.mutter auto-maximize false
set_if_key_exists org.gnome.mutter focus-change-on-pointer-rest false

if command -v snap >/dev/null 2>&1 && snap list firefox >/dev/null 2>&1; then
  set_if_key_exists org.gnome.shell favorite-apps "['firefox_firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Software.desktop', 'org.gnome.Settings.desktop']"
elif command -v firefox >/dev/null 2>&1; then
  set_if_key_exists org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Software.desktop', 'org.gnome.Settings.desktop']"
else
  echo "Firefox desktop id not detected. Leaving favorite apps unchanged."
fi

if gsettings list-schemas | grep -Fx "org.gnome.shell.extensions.user-theme" >/dev/null; then
  enable_shell_extension "user-theme@gnome-shell-extensions.gcampax.github.com"
  gsettings set org.gnome.shell.extensions.user-theme name "WhiteSur-Light"
fi

enable_shell_extension "just-perfection-desktop@just-perfection"
enable_shell_extension "blur-my-shell@aunetx"

configure_gnome_terminal
configure_ptyxis

log "Configuring dock"
if apply_if_schema_exists org.gnome.shell.extensions.ubuntu-dock \
  dock-position "'BOTTOM'" \
  extend-height "false" \
  dash-max-icon-size "56" \
  transparency-mode "'FIXED'" \
  autohide "true" \
  intellihide "true" \
  show-trash "false" \
  show-mounts "false" \
  dock-fixed "false" \
  background-opacity "0.45" \
  show-show-apps-button "false"; then
  echo "Configured ubuntu-dock"
elif apply_if_schema_exists org.gnome.shell.extensions.dash-to-dock \
  dock-position "'BOTTOM'" \
  extend-height "false" \
  dash-max-icon-size "56" \
  transparency-mode "'FIXED'" \
  autohide "true" \
  intellihide "true" \
  show-trash "false" \
  show-mounts "false" \
  dock-fixed "false" \
  background-opacity "0.45" \
  show-show-apps-button "false"; then
  echo "Configured dash-to-dock"
else
  echo "No supported dock schema detected. Skipping dock settings."
fi

if [ "${XDG_SESSION_TYPE:-}" = "wayland" ]; then
  log "Installing Chromium launcher overrides for Wayland sessions"
  local_mime="application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;"
  install_chromium_titlebar_override \
    "google-chrome" \
    "/usr/bin/google-chrome-stable" \
    "google-chrome" \
    "Google Chrome" \
    "${local_mime}x-scheme-handler/google-chrome;"
  install_chromium_titlebar_override \
    "com.google.Chrome" \
    "/usr/bin/google-chrome-stable" \
    "google-chrome" \
    "Google Chrome" \
    "${local_mime}x-scheme-handler/google-chrome;"
  install_chromium_titlebar_override \
    "brave-browser" \
    "/usr/bin/brave-browser-stable" \
    "brave-browser" \
    "Brave Web Browser" \
    "${local_mime}x-scheme-handler/chromium;"
  install_chromium_titlebar_override \
    "com.brave.Browser" \
    "/usr/bin/brave-browser-stable" \
    "brave-browser" \
    "Brave Web Browser" \
    "${local_mime}x-scheme-handler/chromium;"
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
1. Run: $REPO_ROOT/scripts/check.sh
2. Restart Chrome / Brave if they were already open
3. Log out and back in, or reboot so GNOME Shell reloads newly installed extensions
4. Optional manual tuning: $REPO_ROOT/docs/extension-manager-guide.md

EOF
