# af-magic.zsh-theme 
# Modified to some extent here.
#
# Author: Andy Fleming
# URL: http://andyfleming.com/

# Dashed separator size.
afmagic_dashes() {
  local python_env="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"

  if [[ -n $python_env && $PS1 = \(* ]]; then
    print $(( COLUMNS - ${#python_env} - 3 ))
  else
    print $COLUMNS
  fi
}

# Primary prompt: dashed separator, directory, and VCS information.
PS1="${FG[237]}\${(l.\$(afmagic_dashes)..-.)}%{$reset_color%}
${FG[032]}%~\$(git_prompt_info)\$(hg_prompt_info) ${FG[105]}%(!.#.»)%{$reset_color%} "
PS2="%{$fg[red]%}\\ %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

ZSH_THEME_HG_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_HG_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

ZSH_THEME_VIRTUALENV_PREFIX=" ${FG[075]}["
ZSH_THEME_VIRTUALENV_SUFFIX="]%{$reset_color%}"
