# Copy environment.d files
sudo mkdir -p /etc/profile.d/
sudo cp -r $DEFAULT_PATH/profile.d/* /etc/profile.d/

# Setup sddm
sudo mkdir -p /etc/sddm.conf.d

if [ ! -f /etc/sddm.conf.d/autologin.conf ]; then
  cat <<EOF | sudo tee /etc/sddm.conf.d/autologin.conf
[Autologin]
User=$USER
Session=niri

[Theme]
Current=breeze
EOF
fi

sudo systemctl enable sddm.service

# Setup bluetooth
sudo systemctl enable bluetooth.service

# Set default shell
chsh -s /bin/zsh
