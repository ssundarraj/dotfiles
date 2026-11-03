# Rex adds its CLI to terminal environments; also support shells outside Rex.
_dotfiles_rex() {
  if (( $+commands[rex] )); then
    command rex "$@"
  elif [[ -x '/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex' ]]; then
    '/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex' "$@"
  else
    print -u2 'Rex CLI not found. Install Rex or add rex to PATH.'
    return 127
  fi
}

# ra, rf, and rn require Remote Control enabled in Rex Settings → Rex Server.

# Show a session in the app. With no argument, open its native session picker.
# Rex honors REX_CLIENT; otherwise it selects the sole connected app.
ra() {
  local session_info session_id
  if (( $# > 1 )); then
    print -u2 'Usage: ra [session-name-or-id]'
    return 1
  fi
  if [[ -z $1 ]]; then
    _dotfiles_rex do session.switch
    return
  fi
  session_info=$(_dotfiles_rex session inspect "$1" --json) || return
  session_id=$(print -r -- "$session_info" | jq -er '.session_id') || return
  _dotfiles_rex do session.select "session_id=$session_id"
}

# Fuzzy session picker. Keep IDs so duplicate labels remain distinguishable.
rf() {
  local sessions rows selected session_id
  sessions=$(_dotfiles_rex ls --json) || return
  rows=$(print -r -- "$sessions" |
    jq -r '.sessions[] | [.session_id, .label] | @tsv') || return
  if [[ -z $rows ]]; then
    print -u2 'No Rex sessions. Create one with rn <name>.'
    return 1
  fi
  selected=$(print -r -- "$rows" | fzf +m --delimiter=$'\t' \
    --with-nth=2,1 --header='Select a Rex session') || return
  session_id=${selected%%$'\t'*}
  _dotfiles_rex do session.select "session_id=$session_id"
}

# Reuse an exact session label, or create one in a selected ~/dev project.
rn() {
  local session_name=$1 sessions session_id target_dir=$PWD response created
  local -a projects
  if (( $# != 1 )) || [[ -z $session_name || $session_name == -* ]]; then
    print -u2 'Usage: rn <session-name> (name must not start with -)'
    return 1
  fi

  sessions=$(_dotfiles_rex ls --json) || return
  session_id=$(print -r -- "$sessions" | jq -r --arg name "$session_name" '
    [.sessions[] | select(.label == $name)] |
    if length > 1 then error("Duplicate session labels; use rf or ra with an ID")
    elif length == 1 then .[0].session_id else empty end') || return
  if [[ -n $session_id ]]; then
    _dotfiles_rex do session.select "session_id=$session_id"
    return
  fi

  projects=("$HOME"/dev/*(/N))
  if (( ${#projects} )); then
    target_dir=$(print -rl -- "${projects[@]}" |
      fzf +m --query="$session_name" --select-1 \
        --header="Select a directory for $session_name (Esc cancels)") || return
    [[ -n $target_dir ]] || return 1
    printf 'start Rex in %s? [Y/n] ' "$target_dir"
    read -r response || return
    case $response in
      ''|[yY]|[yY][eE][sS]) ;;
      *) target_dir=$PWD ;;
    esac
  fi

  created=$(_dotfiles_rex new "$session_name" -c "$target_dir" --json) || return
  session_id=$(print -r -- "$created" | jq -er '.session_id') || return
  if ! _dotfiles_rex do session.select "session_id=$session_id"; then
    print -u2 "Created session $session_name ($session_id), but could not display it. Use ra $session_id to retry."
    return 1
  fi
}
