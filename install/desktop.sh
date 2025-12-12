# Niri install script: https://yalter.github.io/niri/Getting-Started.html
sudo pacman -Syu --noconfirm niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk alacritty
paru -S --noconfirm dms-shell-bin greetd-dms-greeter-git matugen wl-clipboard cliphist cava qt6-multimedia-ffmpeg
systemctl --user add-wants niri.service dms

# Enable dms greeter
dms greeter enable
dms greeter sync

# Copy Niri config files
mkdir -p $HOME/.config/niri
sudo cp -r $CONFIG_DEFAULT/niri/* $HOME/.config/niri/
