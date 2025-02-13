#
# ZSH Environment Setup
#

# Enable ZSH profiling?
if [[ -n "$ZPROF" ]]; then
  zmodload zsh/zprof
fi

# Ensure compinit is NOT loaded before Zinit loads in ~/zshrc.
skip_global_compinit=1

# ==============================================================================
# PATH Setup
# ==============================================================================

# Ensure values in path variable are unique
typeset -U path

# Prevent loading ZSH startup from files /etc on macOS. The /etc/zprofile file
# screws around with PATH, so we want to avoid it, and instead manually load the
# files we care about.
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Disable loading startup files from /etc
  unsetopt GLOBAL_RCS

  # Setup default PATH just like /etc/zprofile does
  if [ -x "/usr/libexec/path_helper" ]; then
    eval $(/usr/libexec/path_helper -s)
  fi

  # Load /etc/zshenv if it exists
  if [ -f "/etc/zshenv" ]; then
    source "/etc/zshenv"
  fi
fi

# ==============================================================================
# PATH Helpers
# ==============================================================================

path_list () {
  print -l "${(@)path}"
}

path_remove () {
  path=("${(@)path:#$1}")
}

path_append () {
  if [ -d "$1" ]; then
    path+="$1"
  fi
}

path_prepend () {
  if [ -d "$1" ]; then
    path=("$1" "${(@)path:#$1}")
  fi
}

# ==============================================================================
# System Environment Setup
# ==============================================================================

DOTFILES="$HOME/.dotfiles"
DOTBIN="$DOTFILES/bin"
DOTZSH="$DOTFILES/zsh"

# Editors
export EDITOR="emacsclient-wrapper"
export GEM_EDITOR="mate"

# Locale Setup
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# Ensure TMPDIR is the same for local and remote ssh logins
if [[ "$TMPDIR" == "/var/folders/"* ]] || [[ "$TMPDIR" == "" ]]; then
  export TMPDIR="/tmp/user-$USER"
  mkdir -p "$TMPDIR"
fi

# Ensure basic systems paths are in desired order
path_prepend "/bin"
path_prepend "/sbin"
path_prepend "/usr/bin"
path_prepend "/usr/sbin"
path_prepend "/usr/local/bin"
path_prepend "/usr/local/sbin"

# Add dotfiles' bin directory to PATH
path_prepend "$DOTBIN"

# Add user's bin directory to PATH
path_prepend "$HOME/bin"

# ==============================================================================
# Private Dotfiles Environment
# ==============================================================================

DOTPFILES="$DOTFILES/private"

if [ -f "$DOTPFILES/zshenv" ]; then
  source "$DOTPFILES/zshenv"
fi

# ==============================================================================
# Third-party Environment Setup
# ==============================================================================

# Linuxbrew
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  # Inline linux-brew setup to improve shell startup speed by around 200ms.
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}"
  export INFOPATH="${HOMEBREW_PREFIX}/share/info${INFOPATH+:$INFOPATH}"
  path_prepend "${HOMEBREW_PREFIX}/bin"
  path_prepend "${HOMEBREW_PREFIX}/sbin"
fi

# Android SDK environment setup.
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path_append "$ANDROID_HOME/emulator"
  path_append "$ANDROID_HOME/tools"
  path_append "$ANDROID_HOME/tools/bin"
  path_append "$ANDROID_HOME/platform-tools"
fi

# Flutter environment setup
path_append "/opt/flutter/bin"
path_append "/opt/flutter/bin/cache/dart-sdk/bin"

# Use gnu-getop if available
path_prepend "/usr/local/opt/gnu-getopt/bin"

# Homebrew setup
export HOMEBREW_NO_ANALYTICS=1

# Kubernetes setup
export KUBECONFIG="$HOME/.kube/config"
if [ -d "$HOME/.krew" ]; then
  export KREW_ROOT="$HOME/.krew"
  path_append "$HOME/.krew/bin"
fi

# Use custom emacs install if available
path_prepend "/opt/emacs/bin"

# evm setup.
export EVM_MODE=user
export EVM_NATIVE_FULL_AOT=1
path_prepend "$HOME/.evm/shims"

# Set Emacs-related environment variables
export EMACS="emacs"
export EMACSCLIENT="emacsclient"

# On macOS we want to use the Emacs.app application bundle
if [[ "$OSTYPE" == "darwin"* ]]; then
  path_prepend "/Applications/Emacs.app/Contents/MacOS/bin"
  if [ ! -f "/Applications/Emacs.app/Contents/MacOS/bin/emacs" ] && \
    [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
    export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
  fi
fi

# Use custom tmux install if available
path_prepend "/opt/tmux/bin"

# Go setup (./zsh/golang.zsh)
export GOPATH="$HOME/.go"
export GOROOT="$HOME/.local/go"
path_prepend "$GOPATH/bin"

# Ruby setup for rbenv (./zsh/ruby.zsh)
path_prepend "$HOME/.rbenv/shims"

# Python setup for pyenv (./zsh/python.zsh)
path_prepend "$HOME/.pyenv/shims"

# Node setup for volta (./zsh/nodejs.zsh)
path_prepend "$HOME/.volta/bin"

# Rust setup
path_prepend "$HOME/.cargo/bin"

# ==============================================================================
# Path setup for select binaries installed with zinit
# ==============================================================================

path_prepend "$HOME/.local/zsh/zinit/plugins/direnv---direnv"
path_prepend "$HOME/.local/zsh/zinit/plugins/junegunn---fzf"
path_prepend "$HOME/.local/zsh/zinit/plugins/mvdan---sh"
path_prepend "$HOME/.local/zsh/zinit/plugins/pyenv---pyenv/bin"
path_prepend "$HOME/.local/zsh/zinit/plugins/rbenv---rbenv/bin"
path_prepend "$HOME/.local/zsh/zinit/plugins/rclone---rclone"
path_prepend "$HOME/.local/zsh/zinit/plugins/stefanmaric---g/bin"
path_prepend "$HOME/.local/zsh/zinit/plugins/volta-cli---volta"

# ==============================================================================
# Local Overrides
# ==============================================================================

if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
