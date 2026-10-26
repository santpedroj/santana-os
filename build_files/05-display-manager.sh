#!/usr/bin/env bash
set -euo pipefail

# Reuse a packaged boot-time account definition, or supply the original fallback.
if ! grep -Eq '^[[:space:]]*u[[:space:]]+"?greetd"?[[:space:]]' /usr/lib/sysusers.d/*.conf; then
  install -d -m 0755 /usr/lib/sysusers.d
  cat >/usr/lib/sysusers.d/santana-greetd.conf <<'EOF'
u greetd - "greetd greeter" /var/lib/greetd /sbin/nologin
EOF
fi

systemctl unmask greetd.service
systemctl enable --force greetd.service

# Verify the configured login manager and restored image defaults.
rpm -q noctalia-greeter greetd >/dev/null
test -x /usr/bin/noctalia-greeter
test -x /usr/bin/noctalia-greeter-session
test -r /etc/greetd/config.toml
test -r /etc/noctalia-greeter/greeter.toml
test -r /etc/tmpfiles.d/noctalia-greeter.conf
test /etc/systemd/system/display-manager.service -ef /usr/lib/systemd/system/greetd.service
