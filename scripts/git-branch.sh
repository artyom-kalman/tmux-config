#!/usr/bin/env bash
# Truncated git branch for the tmux status bar.

max=28
path="${1:-.}"

cd "$path" 2>/dev/null || { printf '%s\n' '-'; exit 0; }

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || { printf '%s\n' '-'; exit 0; }
[[ -n "$branch" ]] || { printf '%s\n' '-'; exit 0; }

if (( ${#branch} > max )); then
  printf '%s…\n' "${branch:0:$((max - 1))}"
else
  printf '%s\n' "$branch"
fi
