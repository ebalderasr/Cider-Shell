#!/usr/bin/env bash

set_if_key_exists() {
  local schema="$1"
  local key="$2"
  local value="$3"

  if gsettings list-keys "$schema" 2>/dev/null | grep -Fx "$key" >/dev/null; then
    gsettings set "$schema" "$key" "$value"
  fi
}

enable_shell_extension() {
  local uuid="$1"
  local enabled_extensions

  if [ ! -d "$HOME/.local/share/gnome-shell/extensions/$uuid" ] && [ ! -d "/usr/share/gnome-shell/extensions/$uuid" ]; then
    return 0
  fi

  set_if_key_exists org.gnome.shell disable-user-extensions false
  enabled_extensions="$(gsettings get org.gnome.shell enabled-extensions 2>/dev/null || printf '@as []')"

  if [[ "$enabled_extensions" == *"'$uuid'"* ]]; then
    return 0
  fi

  if [ "$enabled_extensions" = "@as []" ] || [ "$enabled_extensions" = "[]" ]; then
    gsettings set org.gnome.shell enabled-extensions "['$uuid']"
  else
    gsettings set org.gnome.shell enabled-extensions "${enabled_extensions%]}, '$uuid']"
  fi
}

configure_gnome_terminal() {
  if ! gsettings writable org.gnome.Terminal.ProfilesList default >/dev/null 2>&1; then
    return 0
  fi

  local profile_uuid profile_path
  profile_uuid="$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')"
  profile_path="/org/gnome/terminal/legacy/profiles:/:${profile_uuid}/"
  gsettings set "org.gnome.Terminal.Legacy.Profile:${profile_path}" use-system-font false
  gsettings set "org.gnome.Terminal.Legacy.Profile:${profile_path}" font "Noto Sans Mono 13"
  gsettings set "org.gnome.Terminal.Legacy.Profile:${profile_path}" default-size-columns 96
  gsettings set "org.gnome.Terminal.Legacy.Profile:${profile_path}" default-size-rows 28
  gsettings set "org.gnome.Terminal.Legacy.Profile:${profile_path}" scrollbar-policy "never"
  gsettings set "org.gnome.Terminal.Legacy.Profile:${profile_path}" visible-name "Cider Light"
}

configure_ptyxis() {
  if ! gsettings list-schemas | grep -Fx "org.gnome.Ptyxis" >/dev/null; then
    return 0
  fi

  set_if_key_exists org.gnome.Ptyxis interface-style "light"
  set_if_key_exists org.gnome.Ptyxis use-system-font false
  set_if_key_exists org.gnome.Ptyxis font-name "Noto Sans Mono 13"
  set_if_key_exists org.gnome.Ptyxis default-columns "96"
  set_if_key_exists org.gnome.Ptyxis default-rows "28"
  set_if_key_exists org.gnome.Ptyxis restore-window-size false
  set_if_key_exists org.gnome.Ptyxis scrollbar-policy "never"
  set_if_key_exists org.gnome.Ptyxis audible-bell false
  set_if_key_exists org.gnome.Ptyxis visual-bell false
  set_if_key_exists org.gnome.Ptyxis cursor-shape "block"

  local profile_uuid profile_path
  profile_uuid="$(gsettings get org.gnome.Ptyxis default-profile-uuid 2>/dev/null | tr -d \')"
  if [ -n "$profile_uuid" ]; then
    profile_path="/org/gnome/Ptyxis/Profiles/${profile_uuid}/"
    if gsettings list-keys "org.gnome.Ptyxis.Profile:${profile_path}" >/dev/null 2>&1; then
      gsettings set "org.gnome.Ptyxis.Profile:${profile_path}" opacity 0.94
      gsettings set "org.gnome.Ptyxis.Profile:${profile_path}" palette "Solarized Light"
      gsettings set "org.gnome.Ptyxis.Profile:${profile_path}" label "Cider Light"
      gsettings set "org.gnome.Ptyxis.Profile:${profile_path}" scrollback-lines 20000
    fi
  fi
}
