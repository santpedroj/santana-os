#!/bin/bash
set -ouex pipefail

# Third-party apps
dnf5 install -y \
  brave-origin

# file manager
dnf5 install -y \
  ark \
  dolphin

# Terminal
dnf5 install -y \
  git \
  kitty \
  neovim \
  tmux \
  zsh

# Functionality
dnf5 install -y \
  kanshi \
  gnome-keyring \
  gnome-keyring-pam \
  grim \
  slurp

echo "Adding Santana OS just recipes"
echo "import \"/usr/share/santana-os/just/santana.just\"" >>/usr/share/ublue-os/just/60-custom.just
