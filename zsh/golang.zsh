#
# Go (golang) environment setup.
#

# ==============================================================================
# global golang packages
# ==============================================================================

install_go_global_packages() {
  local packages=(
    github.com/akavel/up
    github.com/asciimoo/wuzz
    github.com/cweill/gotests/...
    github.com/go-delve/delve/cmd/dlv
    github.com/golang/mock/gomock
    github.com/golang/mock/mockgen
    github.com/kisielk/errcheck
    github.com/mdempsky/unconvert
    github.com/rogpeppe/godef
    golang.org/x/lint/golint
    golang.org/x/tools/cmd/godoc
    golang.org/x/tools/cmd/goimports
    golang.org/x/tools/cmd/guru
    golang.org/x/tools/gopls
    mvdan.cc/gofumpt
    mvdan.cc/gofumpt/gofumports
  )

  for package in "${packages[@]}"; do
    echo "installing/updating \"$package\""
    GO111MODULE=on go get -u "$package"
  done

  if command-exists goenv && [ "$(goenv version-name)" != "system" ]; then
    echo "running: goenv rehash..."
    goenv rehash
  fi
}
