# Refresh all repos
sudo pacman -Syu --noconfirm

# Install base dependencies
sudo pacman -S --needed --noconfirm base-devel

# Install yay
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

# Install pacman packages
mapfile -t packages < <(grep -v '^#' "$CONFIG_INSTALL/pacman.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"

# Install paru packages
mapfile -t packages < <(grep -v '^#' "$CONFIG_INSTALL/aur.packages" | grep -v '^$')
yay -S --noconfirm --needed "${packages[@]}"
