# Cider-Shell

Cider-Shell turns Ubuntu 24.04 + GNOME into a cleaner macOS-style desktop with a copy-paste-friendly installer.

It is designed for users with Ubuntu in English or Spanish. The automated setup uses terminal commands and `gsettings`, so it does not depend on translated menu names. Manual extension steps are documented in both languages.

## What it does

- Installs the base GNOME tools
- Installs the WhiteSur GTK theme, icon theme, and cursors
- Applies a light macOS-style appearance
- Moves window buttons to the left
- Configures the dock at the bottom with auto-hide
- Documents the optional Extension Manager tweaks in English and Spanish

## Tested on

- Ubuntu 24.04
- GNOME 46

## Quick start

If the repo is already on your machine:

```bash
cd ~/github/Cider-Shell
./scripts/install.sh
```

If you cloned it from GitHub:

```bash
git clone <your-repo-url> ~/github/Cider-Shell
cd ~/github/Cider-Shell
./scripts/install.sh
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

## Optional manual finishing steps

Open Extension Manager and install:

- `User Themes`
- `Just Perfection`
- `Blur my Shell`

Then follow the bilingual guide:

- [docs/extension-manager-guide.md](/home/ebald/github/Cider-Shell/docs/extension-manager-guide.md)

## Notes

- Ubuntu usually uses the `ubuntu-dock` schema. Some GNOME setups use `dash-to-dock`. The script detects both.
- The script is intentionally non-destructive. It does not remove your existing themes or extensions.
- A logout or reboot is recommended after installation.

## Spanish

Este repositorio convierte Ubuntu 24.04 + GNOME en un escritorio parecido a macOS con una instalación pensada para copiar y pegar en terminal.

Uso rápido:

```bash
cd ~/github/Cider-Shell
./scripts/install.sh
```

Pasos manuales opcionales:

- instala `User Themes`, `Just Perfection` y `Blur my Shell` en `Administrador de extensiones`
- sigue la guía bilingüe en [docs/extension-manager-guide.md](/home/ebald/github/Cider-Shell/docs/extension-manager-guide.md)
