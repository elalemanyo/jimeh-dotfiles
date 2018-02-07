#
# Node.js
#

# Aliases
alias no="node"
alias np="npm"
alias ni="npm install"
alias ngi="npm install -g"
alias cof="coffee"
alias tl="tldr"

install_node_global_packages () {
  npm install -g \
      eslint \
      eslint-config-prettier \
      eslint-plugin-prettier \
      eslint_d \
      htmllint-cli \
      httpsnippet \
      jsonlint \
      localtunnel \
      prettier \
      tldr \
      tslint \
      typescript \
      typescript-formatter \
      uuid-cli
}

# Load nvm if it's available
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"

  # And it's shell completion
  if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.nvm/bash_completion" ]; then
    source "$HOME/.nvm/bash_completion"
  fi
fi
