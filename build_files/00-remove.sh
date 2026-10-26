#!/usr/bin/env bash
set -xeuo pipefail

# Fedora protects GNOME Shell in gnome-shell.conf or fedora-workstation.conf.
# Remove only GNOME desktop rules, preserving other protected packages.
for config in /etc/dnf/protected.d/*.conf /etc/yum/protected.d/*.conf; do
  if [[ -f "$config" ]]; then
    sed -i -E '/^[[:space:]]*(gnome-shell|gdm)[[:space:]]*$/d' "$config"
  fi
done

# Replace the inherited GNOME desktop with niri and the Noctalia greeter.
packages=(
  # Desktop session and login manager.
  gdm
  gnome-shell
  gnome-shell-common
  'gnome-shell-extension*'
  gnome-session
  gnome-session-common
  gnome-session-wayland-session
  gnome-session-xsession
  gnome-classic-session
  gnome-classic-session-xsession
  gnome-kiosk
  gnome-initial-setup
  gnome-tour
  gnome-remote-desktop

  # GNOME configuration and Shell integration.
  gnome-control-center
  gnome-control-center-filesystem
  gnome-tweaks
  gnome-extensions-app
  gnome-extensions
  gnome-browser-connector
  gnome-menus
  gnome-user-docs
  gnome-user-share
  gnome-backgrounds
  gnome-color-manager
  gnome-rounded-blur

  # Applications replaced by the curated desktop applications.
  nautilus
  'nautilus-*'
  gnome-console
  gnome-terminal
  gnome-terminal-nautilus
  gnome-text-editor
  gedit
  gnome-software
  'gnome-software-*'
  gnome-system-monitor
  gnome-calculator
  gnome-calendar
  gnome-characters
  gnome-clocks
  gnome-contacts
  gnome-font-viewer
  gnome-logs
  gnome-maps
  gnome-weather
  gnome-disk-utility
  gnome-screenshot
  gnome-connections
  baobab
  evince
  evince-libs
  loupe
  eog
  snapshot
  totem
  yelp
)

# Bluefin's package set varies by release. Skip absent packages without hiding
# transaction failures; defer orphan cleanup until the replacement is installed.
installed=$(dnf5 repoquery --installed --queryformat '%{name}\n' "${packages[@]}")
if [[ -n "$installed" ]]; then
  mapfile -t packages_to_remove <<<"$installed"
  dnf5 remove -y --setopt=clean_requirements_on_remove=False "${packages_to_remove[@]}"
fi

# Bluefin also builds Shell extensions directly, outside the RPM database.
rm -rf /usr/share/gnome-shell/extensions
