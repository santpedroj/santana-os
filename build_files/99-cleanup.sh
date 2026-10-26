#!/usr/bin/env bash
set -euo pipefail

# Final cleanup: package transactions and image configuration are complete.
dnf5 clean all
rm -rf /var/lib/dnf/* /var/log/dnf*
rm -rf /run/dnf /run/selinux-policy
rm -rf /tmp/* /var/tmp/* /var/cache/dnf/*

# Confirm the desktop survived package cleanup.
rpm -q niri noctalia >/dev/null
command -v niri >/dev/null
command -v noctalia >/dev/null
# Require at least one packaged Wayland session file.
mapfile -t sessions < <(rpm -ql niri | sed -n '\|^/usr/share/wayland-sessions/.*\.desktop$|p')
(( ${#sessions[@]} > 0 ))
for session in "${sessions[@]}"; do
  test -r "$session"
done

# Keep the RPM database integrity check last, after all package operations.
bash "$(dirname "${BASH_SOURCE[0]}")/shared/verify-rpmdb.sh"
