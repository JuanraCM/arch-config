# Remove sudo-less access
sudo rm -f /etc/sudoers.d/install-mode

# Install webapps
config-webapp-install DeepL https://www.deepl.com/es/translator https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/deepl.png
config-webapp-install YouTube https://www.youtube.com https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/youtube.png
