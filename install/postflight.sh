# Remove sudo-less access
sudo rm -f /etc/sudoers.d/install-mode

# Reboot system
echo -e "\nInstallation complete! The system will reboot now."
sudo reboot now
