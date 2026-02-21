#!/bin/bash

# Install required packages if missing
MISSING_PKGS=()

if ! command -v pkexec &> /dev/null; then
    MISSING_PKGS+=("policykit-1")
fi

if ! dpkg -s wireless-regdb &> /dev/null; then
    MISSING_PKGS+=("wireless-regdb")
fi

if [ ${#MISSING_PKGS[@]} -ne 0 ]; then
    echo "Installing missing dependencies: ${MISSING_PKGS[*]}"
    sudo apt update
    sudo apt install -y "${MISSING_PKGS[@]}"
fi

# Install mainline if missing
if ! command -v mainline &> /dev/null; then
    echo "Mainline not found. Installing..."
    sudo add-apt-repository -y ppa:cappelikan/ppa
    sudo apt update
    sudo apt install -y mainline
fi

# Run your exact command
echo "Installing the latest kernel..."
sudo mainline install-latest

# Ask for reboot
read -p "Kernel installation finished. Do you want to reboot now? (y/n): " answer
case "$answer" in
    [Yy]* )
        echo "Rebooting..."
        sudo reboot
        ;;
    * )
        echo "Reboot skipped. Remember to reboot later to load the new kernel."
        ;;
esac
