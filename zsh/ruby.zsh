#
# Ruby environment setup.
#

# ==============================================================================
# rbenv
# ==============================================================================

# Install rbenv
zinit ice wait lucid as'program' pick'bin/rbenv' from'gh' \
  atclone'src/configure && make -C src' atpull'%atclone' nocompile'!'
zinit light rbenv/rbenv

# install ruby-build
zinit ice wait lucid as'program' pick'bin/ruby-build' from'gh'
zinit light rbenv/ruby-build

# install rbenv-each plugin
zinit ice wait lucid as'program' pick'bin/rbenv-each' from'gh'
zinit light rbenv/rbenv-each

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

# ==============================================================================
# aliases
# ==============================================================================

# bundler
alias bch="bundle check"
alias bcn="bundle clean"
alias bco="bundle console"
alias be="bundle exec"
alias bi="bundle_install"
alias bl="bundle list"
alias bo="bundle open"
alias bp="bundle package"
alias bu="bundle update"

# bundle exec wrappers
alias ru="bundle exec ruby"
alias ra="bundle exec rake"
alias rai="bundle exec rails"
alias rs="bundle exec rspec -f doc"
alias cu="bundle exec cucumber"
alias scu="RAILS_ENV=cucumber bundle exec spring cucumber"

# gems
alias po="powify"
alias lu="lunchy"
alias he="heroku"
alias f="foreman"
alias fs="foreman start"
alias fr="foreman run"
alias pe="procodile exec"
alias sm="schmersion"

# ==============================================================================
# global ruby packages
# ==============================================================================

install_ruby_global_packages() {
  local packages=(
    'bundler:~> 1.0'
    'bundler:~> 2.0'
    brakeman
    bundler-audit
    dotenv
    foreman
    hippo-cli
    lunchy
    method_source
    procodile
    pry-doc
    reek
    rubocop
    rubocop-daemon
    schmersion
    seeing_is_believing
    solargraph
  )

  gem install --no-document rbenv-rehash
  gem install --no-document "${packages[@]}"
}

# ==============================================================================
# bundler
# ==============================================================================

upgrade-bundler() {
  rbenv each -v gem install --no-document 'bundler:~> 1.0' 'bundler:~> 2.0'
}

# ==============================================================================
# solargraph
# ==============================================================================

solargraph-install() {
  rbenv each -v gem install solargraph
}

solargraph-download-cores() {
  rbenv each -v solargraph download-core
}

solargraph-list-versions() {
  rbenv each -v gem list -q solargraph
}

rubygems-upgrade() {
  rbenv each -v gem update --system
}
