#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define globals
export CONFIG_PATH="$HOME/.local/share/arch-config"
export CONFIG_INSTALL="$CONFIG_PATH/install"
export CONFIG_DEFAULT="$CONFIG_PATH/default"
export CONFIG_INSTALL_LOG_FILE="/var/log/arch-config-install.log"
export PATH="$CONFIG_PATH/bin:$PATH"

# Install
source "$CONFIG_INSTALL/helpers/all.sh"

show_header "Installing JuanraCM Config"
start_install_log

run_logged "$CONFIG_INSTALL/preflight.sh"
run_logged "$CONFIG_INSTALL/packaging.sh"
run_logged "$CONFIG_INSTALL/config.sh"
run_logged "$CONFIG_INSTALL/desktop.sh"
source "$CONFIG_INSTALL/postflight.sh"

stop_install_log
show_header "Installation Complete! Reboot when ready."
