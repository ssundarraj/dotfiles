alias ghd='gh dash'
alias gcb='git symbolic-ref --short HEAD'
alias grod='git fetch origin dev && git rebase origin/dev'

# Interactive git branch switcher.
fco() {
  local branches branch previewcmd
  previewcmd="git --no-pager log -50 --color=always --pretty=format:'%Cgreen%h%Cred %al%Creset %s' {1}"
  branches=$(git --no-pager branch) &&
    branch=$(print -r -- "$branches" | fzf +m --preview="$previewcmd") &&
    git switch "${branch##* }"
}
