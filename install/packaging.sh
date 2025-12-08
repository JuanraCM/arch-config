# Refresh all repos
sudo pacman -Syu --noconfirm

# Install base dependencies
sudo pacman -S --needed --noconfirm base-devel

# Install paru
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si --noconfirm
cd ..
rm -rf paru-bin

# Install pacman packages
mapfile -t packages < <(grep -v '^#' "$CONFIG_INSTALL/pacman.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"

# Install paru packages
mapfile -t packages < <(grep -v '^#' "$CONFIG_INSTALL/paru.packages" | grep -v '^$')
paru -S --noconfirm --needed "${packages[@]}"
