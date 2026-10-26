#!/usr/bin/env bash
set -xeuo pipefail

# Fedora protects GNOME Shell in gnome-shell.conf or fedora-workstation.conf.
# Remove only GNOME desktop rules, preserving other protected packages.
for config in /etc/dnf/protected.d/*.conf /etc/yum/protected.d/*.conf; do
  if [[ -f "$config" ]]; then
    sed -i -E '/^[[:space:]]*(gnome-shell|gdm)[[:space:]]*$/d' "$config"
  fi
done

# Remove the GNOME desktop session and login manager.
dnf5 remove -y \
  gdm \
  gnome-shell \
  gnome-shell-common \
  'gnome-shell-extension*' \
  gnome-session \
  gnome-session-common \
  gnome-session-wayland-session \
  gnome-session-xsession \
  gnome-classic-session \
  gnome-classic-session-xsession \
  gnome-kiosk || true

# Remove GNOME desktop configuration and system components.
dnf5 remove -y \
  gnome-control-center \
  gnome-control-center-filesystem \
  gnome-tweaks \
  gnome-extensions-app \
  gnome-extensions \
  gnome-browser-connector \
  gnome-initial-setup \
  gnome-tour \
  gnome-remote-desktop \
  gnome-menus \
  gnome-user-docs \
  gnome-user-share \
  gnome-backgrounds \
  gnome-color-manager \
  gnome-rounded-blur || true

# Remove GNOME applications replaced by the curated desktop applications.
dnf5 remove -y \
  nautilus \
  'nautilus-*' \
  gnome-console \
  gnome-terminal \
  gnome-terminal-nautilus \
  gnome-text-editor \
  gedit \
  gnome-system-monitor \
  gnome-calculator \
  gnome-calendar \
  gnome-characters \
  gnome-clocks \
  gnome-contacts \
  gnome-font-viewer \
  gnome-logs \
  gnome-maps \
  gnome-weather \
  gnome-disk-utility \
  gnome-screenshot \
  gnome-connections \
  malcontent-control \
  baobab \
  evince \
  evince-libs \
  input-remapper \
  ptyxis \
  eog \
  snapshot \
  totem \
  yelp || true

# Remove the inherited GNOME software center and its backends.
dnf5 remove -y \
  gnome-software \
  'gnome-software-*' || true

# Bluefin also builds Shell extensions directly, outside the RPM database.
rm -rf /usr/share/gnome-shell/extensions
