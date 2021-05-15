#! /usr/bin/env bash

#
# Configuration
#

TARGET="$HOME"
DOTFILES_LINK=".dotfiles"
SYMLINK_PATH="$DOTFILES_LINK"
PRIVATE_PATH="private"
SYMLINKS=(
  Brewfile
  ackrc
  alacritty.yml
  bitbar
  coffeelint.json
  config/solargraph/config.yml
  erlang
  eslintrc.js
  gemrc
  gitconfig
  gitignore
  hammerspoon
  hgrc
  hyper.js
  irbrc
  peco
  powconfig
  pryrc
  reek.yml
  rspec
  rubocop.yml
  tmux
  tmux.conf
  zshenv
  zshrc
)

#
# Initial Setup
#

if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  ROOT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
elif [ -n "$0" ] && [ -f "$0" ]; then
  ROOT_PATH=$(cd "$(dirname "$0")" && pwd)
else
  echo "[ERROR] Can't determine dotfiles' root path."
  exit 1
fi

#
# Main Functions
#

install_symlinks() {
  # Symlink dotfiles root
  symlink "$ROOT_PATH" "$TARGET/$DOTFILES_LINK"

  # Setup private dotfiles
  if [ -f "$ROOT_PATH/$PRIVATE_PATH/install.sh" ]; then
    "$ROOT_PATH/$PRIVATE_PATH/install.sh" symlinks
  fi

  # Symlink each path
  for i in "${SYMLINKS[@]}"; do
    dot_symlink "$i" "$SYMLINK_PATH" "$TARGET"
  done
}

install_private() {
  git_clone "git@github.com:jimeh/dotfiles-private.git" \
    "$ROOT_PATH/$PRIVATE_PATH"
}

install_launch_agents() {
  mkdir -p "$HOME/Library/LaunchAgents"
  for file in $ROOT_PATH/launch_agents/*.plist; do
    symlink "$file" "$HOME/Library/LaunchAgents/$(basename "$file")"
  done

  # Setup private launch_agents
  if [ -f "$ROOT_PATH/$PRIVATE_PATH/install.sh" ]; then
    "$ROOT_PATH/$PRIVATE_PATH/install.sh" launch-agents
  fi
}

install_terminfo() {
  for file in $ROOT_PATH/terminfo/*.terminfo; do
    log ok "tic -x" "$file"
    tic -x "$file"
  done
}

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_rbenv() {
  git_clone 'https://github.com/rbenv/rbenv.git' "$TARGET/.rbenv"
  git_clone 'https://github.com/rbenv/ruby-build.git' "$TARGET/.rbenv/plugins/ruby-build"
}

install_emacs_config() {
  git_clone 'https://github.com/plexus/chemacs.git' "$TARGET/.config/chemacs"
  symlink "$TARGET/.config/chemacs/.emacs" "$TARGET/.emacs"
  git_clone 'git@github.com:jimeh/.emacs.d.git' "$TARGET/.emacs.d"
}

#
# Helper functions
#

# Colors
C_RED="$(tput setaf 1)"
C_GREEN="$(tput setaf 2)"
C_YELLOW="$(tput setaf 3)"
C_BLUE="$(tput setaf 4)"
C_MAGENTA="$(tput setaf 5)"
C_CYAN="$(tput setaf 6)"
C_GREY="$(tput setaf 7)"
C_RESET="$(tput sgr0)"

# Symbols
S_RARROW="${C_CYAN}-->${C_RESET}"

log() {
  local type="$1"
  local prefix="$2"
  shift 2
  local message="$@"

  type="$(echo "$type" | tr '[:lower:]' '[:upper:]')"
  case "$type" in
    OK)
      type="${C_GREEN}${type}:${C_RESET}"
      ;;
    WARN | ERROR)
      type="${C_RED}${type}:${C_RESET}"
      ;;
    *)
      type="${C_YELLOW}${type}:${C_RESET}"
      ;;
  esac

  if [ -n "$prefix" ]; then
    prefix="${C_GREY}${prefix}: ${C_RESET}"
  fi

  printf "${type}\t${prefix}${message}\n"
}

symlink() {
  local source="$1"
  local target="$2"
  local linksource

  if [ "$target" == "$source" ]; then
    log ok symlink "$target"
  elif [ ! -e "$target" ] && [ ! -L "$target" ]; then
    log link symlink "$target ${S_RARROW} $source"
    ln -s "$source" "$target"
  elif [ -L "$target" ]; then
    linksource="$(readlink "$target")"
    if [ "$linksource" == "$source" ]; then
      log ok symlink "$target ${S_RARROW} $source"
    else
      log warn symlink "$target ${S_RARROW} $linksource" \
        "${C_CYAN}(should be ${C_RESET}$source${C_CYAN})${C_RESET}"
    fi
  elif [ -f "$target" ]; then
    log warn symlink "$target exists and is a file"
  elif [ -d "$target" ]; then
    log warn symlink "$target exists and is a directory"
  else
    log warn symlink "$target exists"
  fi
}

dot_symlink() {
  local name="$1"
  local source="$2/${name}"
  local target="$3/.${name}"
  local cur_name

  if [ "$(dirname "$name")" != "." ] && [ "$(dirname "$name")" != "/" ]; then
    cur_name="$(dirname "$name")"
    while [ "$cur_name" != "." ] && [ "$cur_name" != "/" ]; do
      source="../${source}"
      cur_name="$(dirname "$cur_name")"
    done
  fi

  symlink "$source" "$target"
}

git_clone() {
  local clone_url="$1"
  local target="$2"

  if [ ! -e "$target" ]; then
    git clone "$clone_url" "$target"
    log ok git-clone "$clone_url ${S_RARROW} $target"
  else
    log info git-clone "$target already exists"
  fi
}

#
# Argument Handling
#

case "$1" in
  symlinks | links)
    install_symlinks
    ;;
  emacs-config | emacs)
    install_emacs_config
    ;;
  private)
    install_private
    ;;
  homebrew | brew)
    install_homebrew
    ;;
  rbenv)
    install_rbenv
    ;;
  launch-agents | launch_agents | agents)
    install_launch_agents
    ;;
  terminfo)
    install_terminfo
    ;;
  info)
    echo "Target directory: $TARGET"
    echo "Detected dotfiles root: $ROOT_PATH"
    ;;
  *)
    echo 'usage: ./install.sh [command]'
    echo ''
    echo 'Available commands:'
    echo '          info: Target and source directory info.'
    echo '      symlinks: Install symlinks for various dotfiles into' \
      'target directory.'
    echo '  emacs_config: Install Emacs configuration.'
    echo '       private: Install private dotfiles.'
    echo '      homebrew: Install Homebrew (Mac OS X only).'
    echo '         rbenv: Install rbenv, a Ruby version manager.'
    echo ' launch_agents: Install launchd plists to ~/Library/LaunchAgents/'
    ;;
esac
