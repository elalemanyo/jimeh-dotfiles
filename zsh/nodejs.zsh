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
  local packages=(
    appcenter-cli
    eslint
    eslint-config-prettier
    eslint-plugin-prettier
    eslint_d
    htmllint-cli
    httpsnippet
    javascript-typescript-langserver
    js-beautify
    jsonlint
    localtunnel
    markdown-it
    prettier
    stylelint
    tslint
    typescript
    typescript-formatter
    uuid-cli
    vscode-css-languageserver-bin
  )

  npm install -g "${packages[@]}"
}

# Load nvm if it's available
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"
fi
