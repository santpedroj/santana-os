# Install curated homebrew packages
santana-install-brews:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Installing Homebrews..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/santpedroj/santana-os/main/repo_files/brews) brew install
    echo "Homebrews installation complete."

# Install my personal flatpaks
santana-install-flatpaks:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Installing Flatpaks..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/santpedroj/santana-os/main/repo_files/flatpaks) flatpak --system -y install
    echo "Flatpaks installation complete."
