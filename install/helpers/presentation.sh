# Get terminal dimensions
if [ -e /dev/tty ]; then
  TERM_SIZE=$(stty size 2>/dev/null </dev/tty)
  if [ -n "$TERM_SIZE" ]; then
    export TERM_HEIGHT=$(echo "$TERM_SIZE" | cut -d' ' -f1)
    export TERM_WIDTH=$(echo "$TERM_SIZE" | cut -d' ' -f2)
  else
    export TERM_WIDTH=80
    export TERM_HEIGHT=24
  fi
else
  export TERM_WIDTH=80
  export TERM_HEIGHT=24
fi

# Tokyo Night theme for gum
export GUM_CONFIRM_PROMPT_FOREGROUND="6"
export GUM_CONFIRM_SELECTED_FOREGROUND="0"
export GUM_CONFIRM_SELECTED_BACKGROUND="2"
export GUM_CONFIRM_UNSELECTED_FOREGROUND="7"
export GUM_CONFIRM_UNSELECTED_BACKGROUND="0"

# Display header with gum, centered in terminal
show_header() {
  local title="$1"
  local color="${2:-2}"  # Default to green (color 2)
  local box_width=50
  
  # Calculate left margin to center the box
  local left_margin=$(( (TERM_WIDTH - box_width) / 2 ))
  
  clear
  gum style \
    --foreground "$color" \
    --border double \
    --border-foreground "$color" \
    --padding "1 2" \
    --margin "1 0 0 $left_margin" \
    --align center \
    --width "$box_width" \
    "$title"
  echo
}
