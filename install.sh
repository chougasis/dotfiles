#!/bin/bash

# Exit on error
set -e

# Update system
sudo pacman -Syu --noconfirm

# Install fish and switch shell
sudo pacman -S fish --noconfirm
echo "Switching default shell to fish..."
chsh -s /bin/fish "$USER" || {
    echo "Error: Failed to switch shell to fish!"
    exit 1
}

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

# Source config.fish with checks
if [ -f ~/.config/fish/config.fish ]; then
    echo "Sourcing ~/.config/fish/config.fish..."
    if command -v fish >/dev/null 2>&1; then
        fish -c "source ~/.config/fish/config.fish && echo 'Successfully sourced ~/.config/fish/config.fish in fish'" || {
            echo "Error: Failed to source ~/.config/fish/config.fish in fish"
            exit 1
        }
    else
        echo "Warning: Zsh not installed, cannot source ~/.config/fish/config.fish properly"
    fi
else
    echo "Error: ~/.config/fish/config.fish not found after copy"
    exit 1
fi

# Start Hyprland
exec hyprland

# Set wallpaper and run pywal
SOURCE_WALLPAPER=~/dotfiles/bulma.jpg
WALLPAPER=~/Pictures/Wallpapers/bulma.jpg

# Check if source wallpaper exists
if [ ! -f "$SOURCE_WALLPAPER" ]; then
    echo "Error: $SOURCE_WALLPAPER not found!"
    exit 1
fi

# Create Screenshots directory
mkdir -p ~/Pictures/Screenshots || {
    echo "Error: Failed to create ~/Pictures/Screenshots!"
    exit 1
}

# Create Wallpapers directory and copy wallpaper
mkdir -p ~/Pictures/Wallpapers || {
    echo "Error: Failed to create ~/Pictures/Wallpapers!"
    exit 1
}

echo "Copying $SOURCE_WALLPAPER to $WALLPAPER..."
cp "$SOURCE_WALLPAPER" "$WALLPAPER" || {
    echo "Error: Failed to copy $SOURCE_WALLPAPER to $WALLPAPER!"
    exit 1
}

# Check if swww is installed
if ! command -v swww >/dev/null 2>&1; then
    echo "Error: swww not installed! Please install it to set the wallpaper."
    exit 1
fi

# Check if wal is installed
if ! command -v wal >/dev/null 2>&1; then
    echo "Error: wal (pywal) not installed! Please install it to generate colors."
    exit 1
fi

# Initialize swww daemon if not running
if ! pgrep -f "swww-daemon" >/dev/null; then
    echo "Starting swww daemon..."
    swww init || {
        echo "Error: Failed to start swww daemon!"
        exit 1
    }
fi

# Set the wallpaper with swww
echo "Setting wallpaper to $WALLPAPER..."
swww img "$WALLPAPER" --transition-type wipe --transition-fps 60 || {
    echo "Error: Failed to set wallpaper with swww!"
    exit 1
}

# Run pywal to generate color scheme based on the wallpaper
echo "Running pywal to generate color scheme..."
wal -i "$WALLPAPER" || {
    echo "Error: Failed to run pywal!"
    exit 1
}
echo "Wallpaper set and color scheme generated successfully!"

# Final message
echo "Installation complete! Please reboot your system to apply all changes."


