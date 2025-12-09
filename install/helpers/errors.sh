# Track if we're already handling an error to prevent double-trapping
ERROR_HANDLING=false

# Cursor is usually hidden while we install
show_cursor() {
  printf "\033[?25h"
}

# Display last N lines from install log
show_log_tail() {
  if [[ -f $CONFIG_INSTALL_LOG_FILE ]]; then
    local log_lines=20
    local max_width=$((TERM_WIDTH - 10))

    tail -n "$log_lines" "$CONFIG_INSTALL_LOG_FILE" | while IFS= read -r line; do
      if ((${#line} > max_width)); then
        line="${line:0:$max_width}..."
      fi
      gum style --foreground 7 "$line"
    done

    echo
  fi
}

# Display the failed command or script name
show_failed_script_or_command() {
  local max_width=$((TERM_WIDTH - 10))
  
  if [[ -n ${CURRENT_SCRIPT:-} ]]; then
    gum style --foreground 9 "Failed script: $CURRENT_SCRIPT"
  else
    local cmd="$BASH_COMMAND"
    if ((${#cmd} > max_width)); then
      cmd="${cmd:0:$max_width}..."
    fi
    gum style --foreground 9 "$cmd"
  fi
}

# Save original stdout and stderr for trap to use
save_original_outputs() {
  exec 3>&1 4>&2
}

# Restore stdout and stderr to original (saved in FD 3 and 4)
# This ensures output goes to screen, not log file
restore_outputs() {
  if [ -e /proc/self/fd/3 ] && [ -e /proc/self/fd/4 ]; then
    exec 1>&3 2>&4
  fi
}

# Error handler
catch_errors() {
  # Prevent recursive error handling
  if [[ $ERROR_HANDLING == true ]]; then
    return
  else
    ERROR_HANDLING=true
  fi

  # Store exit code immediately before it gets overwritten
  local exit_code=$?

  stop_log_output
  restore_outputs
  show_cursor
  clear

  echo
  show_header "Installation Failed!" 9
  echo

  show_log_tail

  gum style --foreground 3 "Exit code: $exit_code"
  show_failed_script_or_command

  echo
  gum style --foreground 6 "Log: $CONFIG_INSTALL_LOG_FILE"

  # Offer options menu
  while true; do
    options=()

    # Add remaining options
    options+=("View full log")
    options+=("Exit")

    choice=$(gum choose "${options[@]}" --header "What would you like to do?" --height 6)

    case "$choice" in
    "View full log")
      if command -v less &>/dev/null; then
        less "$CONFIG_INSTALL_LOG_FILE"
      else
        tail "$CONFIG_INSTALL_LOG_FILE"
      fi
      ;;
    "Exit" | "")
      exit 1
      ;;
    esac
  done
}

# Exit handler - ensures cleanup happens on any exit
exit_handler() {
  local exit_code=$?

  # Only run if we're exiting with an error and haven't already handled it
  if [[ $exit_code -ne 0 && $ERROR_HANDLING != true ]]; then
    catch_errors
  else
    stop_log_output
    show_cursor
  fi
}

# Set up traps
trap catch_errors ERR INT TERM
trap exit_handler EXIT

# Save original outputs in case we trap
save_original_outputs
