#!/bin/bash

# Ensure the script is run as a normal user, not root
if [[ $EUID -eq 0 ]]; then
    echo "Please do not run as root. Run this script as a normal user."
    exit 1
fi

# Step 1: Update the system
echo "Updating the system..."
sudo pacman -Syu --noconfirm

# Step 2: Install paru (AUR Helper) if it's not installed
if ! command -v paru &>/dev/null; then
    echo "paru is not installed. Installing paru..."
    git clone https://aur.archlinux.org/cgit/aur.git/snapshot/paru.tar.gz
    tar -xvzf paru.tar.gz
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru paru.tar.gz # Clean up after installation
else
    echo "paru is already installed."
fi

# Step 3: Use the already cloned dotfiles repo
# Set the alias for the dot command (to make sure it's available for the current session)
echo "Setting up dotfiles..."
alias dot='/usr/bin/git --git-dir=$HOME/dotfiles.git --work-tree=$HOME'

# Apply the dotfiles by checking them out
dot checkout
dot config --local status.showUntrackedFiles no

# Step 4: Install official packages from pkglist.txt
echo "Installing official packages from pkglist.txt..."
sudo pacman -S --needed - < $HOME/dotfiles.git/pkglist.txt

# Step 5: Install AUR packages from aurpkglist.txt
if command -v paru &>/dev/null; then
    echo "Installing AUR packages from aurpkglist.txt..."
    paru -S --needed - < $HOME/dotfiles.git/aurpkglist.txt
else
    echo "paru is not installed. Please install paru and rerun the script."
    exit 1
fi

# Step 6: Automatically replace any references to the old username (chougasis) with the new username
echo "Updating config files with the new username..."
find $HOME/.config/ -type f -exec sed -i "s#/home/chougasis#$HOME#g" {} \;

# Additionally, update username in other important config files, e.g., .zshrc, .profile
sed -i "s#/home/chougasis#$HOME#g" $HOME/.zshrc
sed -i "s#/home/chougasis#$HOME#g" $HOME/.profile

# Step 7: Set default shell to zsh if it's not already set
echo "Setting default shell to zsh..."
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s $(which zsh) $USER # Using sudo to ensure permission
    echo "Default shell changed to zsh. Log out and back in for changes to apply."
fi

# Step 8: Enable necessary services
echo "Enabling necessary services..."
systemctl --user enable pipewire.service
systemctl enable NetworkManager.service

echo "Setup complete! Reboot recommended."

