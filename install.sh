#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define globals
export CONFIG_PATH="$HOME/.local/share/arch-config"
export CONFIG_INSTALL="$CONFIG_PATH/install"
export CONFIG_DEFAULT="$CONFIG_PATH/default"

# Install
source "$CONFIG_INSTALL/preflight.sh"
source "$CONFIG_INSTALL/packaging.sh"
source "$CONFIG_INSTALL/config.sh"
source "$CONFIG_INSTALL/desktop.sh"
source "$CONFIG_INSTALL/postflight.sh"
