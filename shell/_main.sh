#
# Main Shell Setup
#

# Set required path variables
DOTBIN="$DOTFILES/bin"

# Helper Functions
source "$DOTSHELL/helpers.sh"

# Ensure /usr/local/bin is before various system-paths
path_prepend "/usr/local/bin"

# Load bash or zsh specific init files
if [ -n "$BASH_VERSION" ]; then
  source "$DOTSHELL/bashrc.sh"
elif [ -n "$ZSH_VERSION" ]; then
  source "$DOTSHELL/zshrc.sh"
fi

# Aliases
source "$DOTSHELL/aliases.sh"

# Utils
source "$DOTSHELL/emacs.sh"
source "$DOTSHELL/git.sh"
source "$DOTSHELL/tmux.sh"

# Development
source "$DOTSHELL/nodejs.sh"
source "$DOTSHELL/python.sh"
source "$DOTSHELL/ruby.sh"
source "$DOTSHELL/sbcl.sh"

# Services
source "$DOTSHELL/services.sh"

# Environment Setup
source "$DOTSHELL/env.sh"
