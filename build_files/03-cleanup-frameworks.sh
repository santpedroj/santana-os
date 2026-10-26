#!/usr/bin/env bash
set -euo pipefail

# Bluefin erases kernel-devel after removing /usr/src, but can leave its
# kernel-devel-matched metapackage behind with an unsatisfied dependency.
# Erase only that leftover, with RPM dependency checks enabled: never cascade
# into runtime kernel/driver packages or bypass dependencies with --nodeps.
if rpm -q kernel-devel-matched >/dev/null 2>&1 && ! rpm -q kernel-devel >/dev/null 2>&1; then
  echo "Removing orphaned kernel-devel-matched metapackage inherited from Bluefin"
  rpm --erase kernel-devel-matched
fi

# Remove inherited GNOME session frameworks after installing the desktop.
# Keep shared gnome-desktop/online-account libraries, GTK, libadwaita,
# GSettings schemas, gnome-keyring and the portal backends used by niri.
dnf5 remove -y \
  gjs \
  mutter \
  mutter-common \
  gnome-settings-daemon \
  gnome-online-accounts || true

# Follow Gondor's post-install cleanup: remove orphaned dependencies only
# after the replacement desktop and its applications have been installed.
dnf5 autoremove -y || true

# Fail the build if cleanup breaks package dependencies or the chosen desktop.
dnf5 check
rpm -q niri noctalia greetd noctalia-greeter \
  gnome-keyring gnome-keyring-pam \
  xdg-desktop-portal-gtk xdg-desktop-portal-gnome xdg-desktop-portal-kde

for package in gdm gnome-shell gnome-session; do
  if rpm -q "$package" >/dev/null 2>&1; then
    echo "Unexpected GNOME desktop package after cleanup: $package" >&2
    exit 1
  fi
done
