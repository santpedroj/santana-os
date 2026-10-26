#!/usr/bin/env bash
set -euo pipefail

# Use the disabled Terra repo supplied by system_files for these packages.
dnf5 install -y --from-repo=terra --setopt=terra.excludepkgs=noctalia \
  noctalia-greeter \
  nwg-look \
  umbriel-nightly

dnf5 install -y greetd

# niri
dnf5 install -y \
  niri \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-gnome \
  xdg-desktop-portal-kde

# Use Fedora's Noctalia shell; Terra stays disabled outside explicit installs.
# Synchronize an inherited package too: install alone keeps it if already present.
if rpm -q noctalia >/dev/null 2>&1; then
  dnf5 distro-sync -y --refresh --from-repo=fedora,updates noctalia
else
  dnf5 install -y --refresh --from-repo=fedora,updates noctalia
fi

# theming
dnf5 install -y \
  adw-gtk3-theme \
  qt6ct

# Build-time RPM state is replaced by the system_files configuration afterward.
rm -rf /var/lib/greetd/.config
