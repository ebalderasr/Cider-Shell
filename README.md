# Cider-Shell

Cider-Shell turns Ubuntu 24.04 + GNOME into a cleaner macOS-style desktop with a copy-paste-friendly installer.

It is designed for users with Ubuntu in English or Spanish. The automated setup uses terminal commands and `gsettings`, so it does not depend on translated menu names. Manual extension steps are documented in both languages.

![Cider-Shell preview](assets/previews/cider-shell-preview.svg)

## What it does

- Installs the base GNOME tools
- Installs the WhiteSur GTK theme, icon theme, and cursors
- Applies a light macOS-style appearance
- Moves window buttons to the left
- Configures the dock at the bottom with auto-hide
- Applies extra GNOME polish with a post-install step
- Verifies the final setup with a check script
- Documents the optional Extension Manager tweaks in English and Spanish

## Tested on

- Ubuntu 24.04
- GNOME 46

## Quick start

If the repo is already on your machine:

```bash
cd ~/github/Cider-Shell
./scripts/install.sh
./scripts/post-install.sh
./scripts/check.sh
```

If you cloned it from GitHub:

```bash
git clone <your-repo-url> ~/github/Cider-Shell
cd ~/github/Cider-Shell
./scripts/install.sh
./scripts/post-install.sh
./scripts/check.sh
```

## What the installer changes

The installer applies these system settings:

- `WhiteSur-Light` GTK theme
- `WhiteSur` icon theme
- `WhiteSur-cursors` cursor theme
- light color scheme
- left-side window buttons
- bottom dock
- dock auto-hide
- 56px dock icons
- Cantarell fonts as a safe default

It also installs:

- `gnome-tweaks`
- `gnome-shell-extension-manager`
- `gnome-shell-extensions`
- build dependencies needed by WhiteSur

## Included scripts

- `./scripts/install.sh`: installs themes, packages, base GNOME settings, and runs post-install polish
- `./scripts/post-install.sh`: reapplies extra polish safely after you install extensions
- `./scripts/check.sh`: validates the current configuration and reports missing pieces
- `./scripts/apply-wallpaper.sh`: applies one of the bundled wallpapers or a custom local file
- `./scripts/uninstall.sh`: reverts the GNOME settings changed by Cider-Shell

## Preview and wallpapers

The repo now includes:

- `assets/previews/cider-shell-preview.svg`: a layout preview of the intended result
- `assets/wallpapers/daybreak.svg`
- `assets/wallpapers/tide.svg`

Apply the bundled wallpaper:

```bash
cd ~/github/Cider-Shell
./scripts/apply-wallpaper.sh daybreak.svg
```

List available wallpapers:

```bash
cd ~/github/Cider-Shell
./scripts/apply-wallpaper.sh --list
```

## What is still manual

Some GNOME extensions are safer to leave as manual installs because packaging varies across Ubuntu and GNOME versions.

Install and enable these in Extension Manager:

- `User Themes`
- `Just Perfection`
- `Blur my Shell`

Then run:

```bash
cd ~/github/Cider-Shell
./scripts/post-install.sh
./scripts/check.sh
```

## Optional manual finishing steps

Open Extension Manager and install:

- `User Themes`
- `Just Perfection`
- `Blur my Shell`

Then follow the bilingual guide:

- [docs/extension-manager-guide.md](/home/ebald/github/Cider-Shell/docs/extension-manager-guide.md)
- [docs/visual-finishing.md](/home/ebald/github/Cider-Shell/docs/visual-finishing.md)

## Troubleshooting

- `Shell theme did not change`
  Install and enable `User Themes`, then run `./scripts/post-install.sh` again and log out.
- `Dock settings did not apply`
  Run `./scripts/check.sh` to see whether your system is using `ubuntu-dock` or `dash-to-dock`.
- `Blur my Shell or Just Perfection settings were skipped`
  The extension must be installed and enabled before `./scripts/post-install.sh` can configure it.
- `Wallpaper did not update`
  Run `./scripts/apply-wallpaper.sh daybreak.svg` manually, then log out and back in if needed.
- `I want to revert everything`
  Run `./scripts/uninstall.sh`. This resets GNOME settings but does not remove installed packages or themes from disk.

## Notes

- Ubuntu usually uses the `ubuntu-dock` schema. Some GNOME setups use `dash-to-dock`. The script detects both.
- The script is intentionally non-destructive. It does not remove your existing themes or extensions.
- Shell theme and extension-specific tweaks are applied automatically only if the matching schema exists.
- A logout or reboot is recommended after installation.

## Spanish

Este repositorio convierte Ubuntu 24.04 + GNOME en un escritorio parecido a macOS con una instalación pensada para copiar y pegar en terminal.

Uso rápido:

```bash
cd ~/github/Cider-Shell
./scripts/install.sh
./scripts/post-install.sh
./scripts/check.sh
```

Pasos manuales opcionales:

- instala `User Themes`, `Just Perfection` y `Blur my Shell` en `Administrador de extensiones`
- ejecuta `./scripts/post-install.sh`
- ejecuta `./scripts/check.sh`
- si quieres cambiar el fondo, ejecuta `./scripts/apply-wallpaper.sh daybreak.svg`
- si quieres revertir los ajustes, ejecuta `./scripts/uninstall.sh`
- sigue las guías en [docs/extension-manager-guide.md](/home/ebald/github/Cider-Shell/docs/extension-manager-guide.md) y [docs/visual-finishing.md](/home/ebald/github/Cider-Shell/docs/visual-finishing.md)
