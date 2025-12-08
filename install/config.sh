# Copy environment.d files
sudo mkdir -p /etc/profile.d/
sudo cp -r $CONFIG_DEFAULT/profile.d/* /etc/profile.d/

# Setup sddm
sudo mkdir -p /etc/sddm.conf.d

if [ ! -f /etc/sddm.conf.d/autologin.conf ]; then
  sudo tee /etc/sddm.conf.d/autologin.conf <<EOF >/dev/null
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

# Setup limine
[[ -f /boot/EFI/limine/limine.conf ]] || [[ -f /boot/EFI/BOOT/limine.conf ]] && EFI=true

# Conf location is different between EFI and BIOS
if [[ -n "$EFI" ]]; then
  # Check USB location first, then regular EFI location
  if [[ -f /boot/EFI/BOOT/limine.conf ]]; then
    limine_config="/boot/EFI/BOOT/limine.conf"
  else
    limine_config="/boot/EFI/limine/limine.conf"
  fi
else
  limine_config="/boot/limine/limine.conf"
fi

if [[ ! -f $limine_config ]]; then
  echo "Error: Limine config not found at $limine_config" >&2
  exit 1
fi

CMDLINE=$(cat /proc/cmdline)
  sudo tee /etc/default/limine <<EOF >/dev/null
TARGET_OS_NAME="Arch Linux"

ESP_PATH="/boot"

KERNEL_CMDLINE[default]="$CMDLINE"
KERNEL_CMDLINE[default]+="quiet splash"

ENABLE_UKI=yes
CUSTOM_UKI_NAME="arch"

ENABLE_LIMINE_FALLBACK=yes

FIND_BOOTLOADERS=yes

BOOT_ORDER="*, *fallback, Snapshots"
ENABLE_SORT=no
EOF

sudo cp $CONFIG_DEFAULT/limine/limine.conf /boot/limine.conf
sudo rm "$limine_config"

sudo limine-update
