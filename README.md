# dotfiles



## Name
Dotfiles For A Friend
## Description
My friend wants to try Arch Linux, but instead of starting from scratch he just wanted to try my simple setup. This is for you friend.
## Installation
After installing Arch Linux do the following:

Update System:

sudo pacman -Syu


Set up Home Directories (ie. Downloads, Videos, Music, ect...)

sudo pacman -S xdg-user-dirs
xdg-user-dirs-update
(ls to confirm the directories are there)


Set Up zsh (Shell alternative to bash)

sudo pacman -S zsh
chsh -s /bin/zsh

Reboot and log back in

Press 0


Install git (This is to allow you to clone repositories from github and gitlab):

sudo pacman -S git


Install paru (This is to install packages from the AUR, example, paru -S arch-update):

sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si


Install the following packages (sudo pacman -S insertpackage)

7zip                        (yazi)
discord
dolphin                     (gui file manager)
dunst                       (notification daemon)
ethtool                     (helps manage ethernet settings)
fastfetch                   (displays system info but in the cool Arch Linux way)
fd                          (yazi)
ffmpeg                      (yazi)
fzf                         (yazi)
gnome-disk-utility          (gui disk management)
grim                        (needed for screenshots)
hyprland                    (Desktop Environment, Window Manager)
hyprpolkitagent             (needed when messing with some settings, mostly for Disks)
imagemagick                 (yazi)
jq                          (yazi)
kio-admin                   (allows you to enter root in Dolphin)
kitty                       (terminal)
nerd-fonts                  (just install all of them)
pavucontorl                 (gui audio controller)
poppler                     (yazi)
ripgrep                     (yazi)
sddm                        (Log-In screen)
slurp                       (needed for screenshots)
speedtest-cli               (cli for testing internet speed)
steam 
swww                        (wallpaper daemon)
waybar                      (like the Windows taskbar)
wireplumber                 (Audio Stuff)
wl-clipboard                (for copying and pasting)
wofi                        (App Menu)
xdg-desktop-portal-hyprland (needed to screenshare)
yazi                        (terminal file manager)
zoxide                      (yazi)


Install the following packages (paru -S insertpackage)

arch-update                 (updates everything and allows you delete orphaned packages)
hyprshot                    (needed for screenshots)
librewolf-bin               (get the -bin version, the other one takes too long to install and breaks)
python-pywal16              (auto-generate system theme)
waypaper                    (gui wallpaper selector)