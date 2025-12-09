start_log_output() {
  local ANSI_SAVE_CURSOR="\033[s"
  local ANSI_RESTORE_CURSOR="\033[u"
  local ANSI_CLEAR_LINE="\033[2K"
  local ANSI_HIDE_CURSOR="\033[?25l"
  local ANSI_RESET="\033[0m"
  local ANSI_GRAY="\033[90m"

  printf "$ANSI_SAVE_CURSOR"
  printf "$ANSI_HIDE_CURSOR"

  (
    local log_lines=20
    local max_width=$((TERM_WIDTH - 10))

    while true; do
      mapfile -t current_lines < <(tail -n "$log_lines" "$CONFIG_INSTALL_LOG_FILE" 2>/dev/null)

      output=""
      for ((i = 0; i < log_lines; i++)); do
        line="${current_lines[i]:-}"

        if [ ${#line} -gt $max_width ]; then
          line="${line:0:$max_width}..."
        fi

        if [ -n "$line" ]; then
          output+="${ANSI_CLEAR_LINE}${ANSI_GRAY}  → ${line}${ANSI_RESET}\n"
        else
          output+="${ANSI_CLEAR_LINE}\n"
        fi
      done

      printf "${ANSI_RESTORE_CURSOR}%b" "$output"
      sleep 0.1
    done
  ) &
  monitor_pid=$!
}

stop_log_output() {
  if [ -n "${monitor_pid:-}" ]; then
    kill $monitor_pid 2>/dev/null || true
    wait $monitor_pid 2>/dev/null || true
    unset monitor_pid
  fi
}

start_install_log() {
  sudo touch "$CONFIG_INSTALL_LOG_FILE"
  sudo chmod 666 "$CONFIG_INSTALL_LOG_FILE"

  export CONFIG_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')

  echo "=== Configuration Installation Started: $CONFIG_START_TIME ===" >>"$CONFIG_INSTALL_LOG_FILE"
  start_log_output
}

stop_install_log() {
  stop_log_output
  show_cursor

  if [[ -n ${CONFIG_INSTALL_LOG_FILE:-} ]]; then
    CONFIG_END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    echo "=== Configuration Installation Completed: $CONFIG_END_TIME ===" >>"$CONFIG_INSTALL_LOG_FILE"
    echo "" >>"$CONFIG_INSTALL_LOG_FILE"
    echo "=== Installation Time Summary ===" >>"$CONFIG_INSTALL_LOG_FILE"

    if [ -n "$CONFIG_START_TIME" ]; then
      CONFIG_START_EPOCH=$(date -d "$CONFIG_START_TIME" +%s)
      CONFIG_END_EPOCH=$(date -d "$CONFIG_END_TIME" +%s)
      CONFIG_DURATION=$((CONFIG_END_EPOCH - CONFIG_START_EPOCH))

      CONFIG_MINS=$((CONFIG_DURATION / 60))
      CONFIG_SECS=$((CONFIG_DURATION % 60))

      echo "Config:      ${CONFIG_MINS}m ${CONFIG_SECS}s" >>"$CONFIG_INSTALL_LOG_FILE"
    fi
    echo "=================================" >>"$CONFIG_INSTALL_LOG_FILE"
  fi
}

run_logged() {
  local script="$1"

  export CURRENT_SCRIPT="$script"

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script" >>"$CONFIG_INSTALL_LOG_FILE"

  # Use bash -c to create a clean subshell
  bash -c "source '$script'" </dev/null >>"$CONFIG_INSTALL_LOG_FILE" 2>&1

  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script" >>"$CONFIG_INSTALL_LOG_FILE"
    unset CURRENT_SCRIPT
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)" >>"$CONFIG_INSTALL_LOG_FILE"
  fi

  return $exit_code
}
