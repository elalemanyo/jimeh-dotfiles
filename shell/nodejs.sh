#
# Node.js
#

# Aliases
alias no="node"
alias np="npm"
alias ni="npm install"
alias ngi="npm install -g"
alias cof="coffee"

install_node_global_packages () {
  npm install -g \
      eslint \
      eslint-config-semistandard \
      eslint-config-standard \
      eslint-config-standard \
      eslint-plugin-promise \
      eslint-plugin-promise \
      eslint-plugin-react \
      eslint-plugin-standard \
      eslint-plugin-standard \
      jsfmt \
      jslinter \
      jsonlint \
      semistandard \
      semistandard-format \
      standard \
      standard-format \
      tslint \
      typescript \
      typescript-formatter
}

# Load nvm if it's available
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"

  # And it's shell completion
  if [ -f "$HOME/.nvm/bash_completion" ]; then
    source "$HOME/.nvm/bash_completion"
  fi
fi
