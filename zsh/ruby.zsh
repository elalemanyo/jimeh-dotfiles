#
# Ruby environment setup.
#

install_ruby_global_packages () {
  local packages=(
    'bundler:~> 1.0'
    'bundler:~> 2.0'
    brakeman
    bundler-audit
    foreman
    lunchy
    method_source
    procodile
    pry-doc
    rbenv-rehash
    reek
    rubocop
    seeing_is_believing
    solargraph
  )

  gem install --no-document "${packages[@]}"
}

# Aliases
alias po="powify"
alias lu="lunchy"
alias he="heroku"
alias f="foreman"
alias fs="foreman start"
alias fr="foreman run"

# Aliases for specific ruby commands
alias ru="bundle exec ruby"
alias ra="bundle exec rake"
alias rai="bundle exec rails"
alias rs="bundle exec rspec -f doc"
alias cu="bundle exec cucumber"
alias scu="RAILS_ENV=cucumber bundle exec spring cucumber"

# Bundler aliases
alias bch="bundle check"
alias bcn="bundle clean"
alias bco="bundle console"
alias be="bundle exec"
alias bi="bundle_install"
alias bl="bundle list"
alias bo="bundle open"
alias bp="bundle package"
alias bu="bundle update"

if (( $+commands[rbenv] )); then
  # lazy-load rbenv
  rbenv() {
    load-rbenv
    rbenv "$@"
  }

  _rbenv() {
    load-rbenv
    _rbenv "$@"
  }

  compctl -K _rbenv rbenv

  load-rbenv() {
    unset -f load-rbenv _rbenv rbenv
    eval "$(command rbenv init -)"
  }

  rbenv-each-version () {
    local current_version="$RBENV_VERSION"

    for v in $(ls "${HOME}/.rbenv/versions"); do
      echo "==> Ruby $v:"
      export RBENV_VERSION="$v"
      eval $*
    done

    export RBENV_VERSION="$current_version"
  }
fi

# Solargraph related commands

solargraph-install () {
  rbenv-each-version "gem install solargraph"
}

solargraph-download-cores () {
  rbenv-each-version "solargraph download-core"
}

solargraph-list-versions () {
  rbenv-each-version "gem list -q solargraph"
}

rubygems-upgrade () {
  rbenv-each-version "gem update --system"
}

upgrade-bundler () {
  rbenv-each-version \
    "gem install --no-document 'bundler:~> 1.0' 'bundler:~> 2.0'"
}
