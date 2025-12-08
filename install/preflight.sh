# Setup sudo-less access
sudo tee /etc/sudoers.d/install-mode >/dev/null <<EOF
$USER ALL=(ALL) NOPASSWD: /usr/bin/chsh
$USER ALL=(ALL) NOPASSWD: ALL
EOF
sudo chmod 440 /etc/sudoers.d/install-mode

# Setup pacman config
sudo cp "$CONFIG_DEFAULT/pacman/pacman.conf" /etc/pacman.conf
