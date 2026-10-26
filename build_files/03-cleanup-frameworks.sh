#!/usr/bin/env bash
set -euo pipefail

# Release inherited GNOME frameworks after installing the replacement desktop.
# Let DNF retain any libraries still required by portals or other applications.
# In particular, keep GTK/libadwaita, GSettings schemas, gnome-keyring and the
# GNOME portal needed by niri; a blanket 'gnome-*' removal would break them.
dnf5 mark dependency --skip-unavailable \
  gjs \
  'mutter*' \
  'gnome-desktop*' \
  'gnome-online-accounts*' \
  'gnome-settings-daemon*' \
  'evolution-data-server*' \
  gnome-menus \
  libgnomekbd \
  libgweather

dnf5 autoremove -y

# Fail the build if cleanup breaks package dependencies or the chosen desktop.
dnf5 check
rpm -q niri noctalia greetd noctalia-greeter \
  gnome-keyring gnome-keyring-pam \
  xdg-desktop-portal-gtk xdg-desktop-portal-gnome xdg-desktop-portal-kde >/dev/null

for package in gdm gnome-shell gnome-session; do
  if rpm -q "$package" >/dev/null 2>&1; then
    echo "Unexpected GNOME desktop package after cleanup: $package" >&2
    exit 1
  fi
done
