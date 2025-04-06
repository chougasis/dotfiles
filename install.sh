#!/bin/bash

# Ensure the script is run as a normal user, not root
if [[ $EUID -eq 0 ]]; then
    echo "Please do not run as root. Run this script as a normal user."
    exit 1
fi

# Step 1: Apply dotfiles from the cloned repo
echo "Applying dotfiles..."
git --git-dir=$HOME/dotfiles --work-tree=$HOME checkout
git --git-dir=$HOME/dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no

# Step 2: Update username references in config files
echo "Updating config files with the new username..."
find $HOME/.config/ -type f -exec sed -i "s#/home/chougasis#$HOME#g" {} \;
sed -i "s#/home/chougasis#$HOME#g" $HOME/.zshrc
sed -i "s#/home/chougasis#$HOME#g" $HOME/.profile

# Step 3: Enable necessary services
echo "Enabling necessary services..."
systemctl --user enable pipewire.service
systemctl enable NetworkManager.service
systemctl enable sddm.service

echo "Setup complete! Reboot recommended."



