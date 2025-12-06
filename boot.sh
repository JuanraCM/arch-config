#!/bin/bash

clear

sudo pacman -Syu --noconfirm --needed git

REPO_URL="JuanraCM/arch-config"

echo -e "\nCloning config from: https://github.com/${REPO_URL}.git"
rm -rf ~/.local/share/arch-config/
git clone "https://github.com/${REPO_URL}.git" ~/.local/share/arch-config >/dev/null

echo -e "\nInstallation starting..."
source ~/.local/share/arch-config/install.sh
