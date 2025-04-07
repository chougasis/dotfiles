#!/bin/bash

# Exit on error
set -e

# Update system
sudo pacman -Syu --noconfirm

# Install xdg-user-dirs and create default user directories
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

# Install 7zip and Neovim
sudo pacman -S 7zip neovim --noconfirm

# Install paru if not already installed
if ! command -v paru >/dev/null 2>&1; then
    sudo pacman -S --needed base-devel --noconfirm
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
fi

# Install from pkglist.txt
[ -f ~/dotfiles/pkglist.txt ] || { echo "pkglist.txt missing"; exit 1; }
sudo pacman -S --needed - < pkglist.txt --noconfirm

# Install from aurpkglist.txt
[ -f ~/dotfiles/aurpkglist.txt ] || { echo "aurpkglist.txt missing"; exit 1; }
paru -S --needed - < aurpkglist.txt --noconfirm

# Enable SDDM and set Hyprland as default
sudo systemctl enable sddm
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Autologin]\nUser=\nSession=hyprland.desktop" | sudo tee /etc/sddm.conf.d/hyprland.conf
echo -e "[General]\nSession=hyprland.desktop" | sudo tee -a /etc/sddm.conf.d/hyprland.conf

# Copy dotfiles
cp -r ~/dotfiles/.config/* ~/.config/
cp ~/dotfiles/.zshrc ~/.zshrc

# Source .zshrc with checks
if [ -f ~/.zshrc ]; then
    echo "Sourcing ~/.zshrc..."
    if command -v zsh >/dev/null 2>&1; then
        zsh -c "source ~/.zshrc && echo 'Successfully sourced ~/.zshrc in Zsh'" || {
            echo "Error: Failed to source ~/.zshrc in Zsh"
            exit 1
        }
    else
        echo "Warning: Zsh not installed, cannot source ~/.zshrc properly"
    fi
else
    echo "Error: ~/.zshrc not found after copy"
    exit 1
fi

# Final message
echo "Installation complete! Please reboot your system to apply all changes."


