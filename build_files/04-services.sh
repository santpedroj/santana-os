#!/usr/bin/env bash
set -euo pipefail

systemctl set-default graphical.target
systemctl enable podman.socket
