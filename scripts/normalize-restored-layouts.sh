#!/usr/bin/env bash

# Resurrect restores the saved layout dimensions verbatim. If an attached
# client has a different size, tmux can leave unused rows and columns around
# the restored panes. Force mismatched layouts through a size recalculation.
# Ignore detached sessions because tmux would size them to its 80x24 fallback.
declare -A seen_windows=()

while IFS= read -r session_id; do
  [[ -n "$session_id" ]] || continue

  while IFS=' ' read -r window_id window_size layout; do
    [[ -z "${seen_windows[$window_id]+present}" ]] || continue
    seen_windows[$window_id]=1

    layout_size="${layout#*,}"
    layout_size="${layout_size%%,*}"

    if [[ "$layout_size" != "$window_size" ]]; then
      tmux resize-window -A -t "$window_id"
      tmux set-option -wu -t "$window_id" window-size
    fi
  done < <(tmux list-windows -t "$session_id" -F '#{window_id} #{window_width}x#{window_height} #{window_layout}')
done < <(tmux list-clients -F '#{session_id}')
