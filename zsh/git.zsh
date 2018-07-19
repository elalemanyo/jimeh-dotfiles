#
# Git
#

# Aliases
alias g="git"
alias gi="git"
alias ga="git add"
alias gb="git branch"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gr="git remote"
alias gs="git status"
alias gai="git add -i"
alias gp="git push"
alias gf="git fetch"
alias gd="git difftool"
alias gpl="git pull --rebase"
alias gix="gitx"
alias gx="gitx"

# Git Completion
if [ -n "$BASH_VERSION" ]; then
  if [ -f "/usr/local/etc/bash_completion.d/git-completion.bash" ]; then
    source "/usr/local/etc/bash_completion.d/git-completion.bash"
  fi

  # Only needed for Bash. Zsh is much smarter with it's auto-completion ^_^
  complete -o default -o nospace -F _git g
  complete -o default -o nospace -F _git gi
fi
