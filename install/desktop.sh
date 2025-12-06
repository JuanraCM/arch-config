# Setup sddm
sudo mkdir -p /etc/sddm.conf.d

if [ ! -f /etc/sddm.conf.d/autologin.conf ]; then
  cat <<EOF | sudo tee /etc/sddm.conf.d/autologin.conf
[Theme]
Current=breeze
EOF
fi

sudo systemctl enable sddm.service

# Niri install script: https://yalter.github.io/niri/Getting-Started.html
sudo pacman -Syu --noconfirm niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk alacritty
paru -S --noconfirm dms-shell-bin matugen wl-clipboard cliphist cava qt6-multimedia-ffmpeg
systemctl --user add-wants niri.service dms

# Set default shell
chsh -s /bin/zsh
