# Attach to a tmux session, or switch the current tmux client to it.
ta() {
  local session_name=$1

  if [[ -n $TMUX ]]; then
    if [[ -z $session_name ]]; then
      print -u2 'Usage: ta <session-name>'
      return 1
    fi
    tmux switch-client -t "$session_name"
  elif [[ -n $session_name ]]; then
    tmux attach -t "$session_name"
  else
    tmux attach
  fi
}

# Switch/create a Worktrunk worktree, then enter its tmux session.
wtn() {
  wt switch "$@" && wt attach
}

# Fuzzy tmux session attach/switch.
tf() {
  local sessions session
  sessions=$(tmux ls | awk -F: '{print $1}') &&
    session=$(print -r -- "$sessions" | fzf +m) || return

  if [[ -n $TMUX ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach -t "$session"
  fi
}

# Attach to an existing tmux session, or create one in a selected ~/dev project.
tn() {
  local session_name=$1
  local target_dir=""
  local response
  local -a tmux_cmd

  if [[ -z $session_name ]]; then
    print -u2 'Usage: tn <session-name>'
    return 1
  fi

  if tmux has-session -t "$session_name" 2>/dev/null; then
    if [[ -n $TMUX ]]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach -t "$session_name"
    fi
    return
  fi

  if [[ -d $HOME/dev ]]; then
    target_dir=$(find "$HOME/dev" -mindepth 1 -maxdepth 1 -type d 2>/dev/null |
      fzf --query="$session_name" --select-1 --exit-0 \
        --header="Select a directory for $session_name")

    if [[ -n $target_dir ]]; then
      printf 'start tmux in %s? [Y/n] ' "$target_dir"
      read -r response
      print
      case $response in
        ''|[yY]|[yY][eE][sS]) ;;
        *) target_dir="" ;;
      esac
    fi
  fi

  tmux_cmd=(tmux new-session -s "$session_name")
  [[ -n $target_dir ]] && tmux_cmd+=(-c "$target_dir")

  if [[ -n $TMUX ]]; then
    tmux_cmd=(tmux new-session -d -s "$session_name")
    [[ -n $target_dir ]] && tmux_cmd+=(-c "$target_dir")
    "${tmux_cmd[@]}" && tmux switch-client -t "$session_name"
  else
    "${tmux_cmd[@]}"
  fi
}
