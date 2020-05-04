# frozen_string_literal: true

require 'fileutils'

#
# Setup
#

hostname = `hostname -s`.strip
cask_args appdir: '/Applications'
tap 'homebrew/cask'
tap 'homebrew/cask-drivers'
tap 'homebrew/cask-versions'

#
# Command-Line Tools (Brew)
#

brew 'ack'
brew 'aspell'
brew 'bash'
brew 'bazaar'
brew 'colordiff'
brew 'coreutils'
brew 'ctop'
brew 'dep'
brew 'dpkg'
brew 'geckodriver'
brew 'git'
brew 'git-crypt'
brew 'git-standup'
brew 'global'
brew 'go'
brew 'hey'
brew 'highlight'
brew 'htop'
brew 'httpie'
brew 'jq'
brew 'less'
brew 'lua'
brew 'luarocks'
brew 'mas'
brew 'mosh'
brew 'node'
brew 'pandoc'
brew 'peco'
brew 'pgformatter'
brew 'postgresql'
brew 'rbenv'
brew 'rclone'
brew 'readline'
brew 'reattach-to-user-namespace'
brew 'redis'
brew 'ruby-build'
brew 'rustup-init'
brew 'shellcheck'
brew 'source-highlight'
brew 'telnet'
brew 'the_silver_searcher'
brew 'tldr'
brew 'tmux'
brew 'tree'
brew 'watch'
brew 'wget'
brew 'yank'
brew 'yarn'
brew 'zsh'

# Custom taps

tap 'golangci/tap'
brew 'golangci-lint'

tap 'goreleaser/tap'
brew 'goreleaser'

tap 'heroku/brew'
brew 'heroku'

tap 'nektos/tap'
brew 'act'

# sshfs requires osxfuse

cask 'osxfuse'
brew 'sshfs'

#
# Desktop Apps (Cask)
#

# Core Apps
cask '1password'
cask 'aerial'
cask 'alfred'
cask 'appcleaner'
cask 'bartender'
cask 'betterzip'
cask 'bitbar'
cask 'daisydisk'
cask 'emacs'
cask 'firefox'
cask 'fluid'
cask 'flux'
cask 'google-chrome'
cask 'gpg-suite'
cask 'hammerspoon'
cask 'iina'
cask 'intel-power-gadget'
cask 'istat-menus'
cask 'iterm2'
cask 'karabiner-elements'
cask 'logitech-options'
cask 'mplayerx'
cask 'name-mangler'
cask 'resolutionator'
cask 'soulver2'
cask 'stay'
cask 'ubersicht'
cask 'vlc'

# Fonts
tap 'homebrew/cask-fonts'
cask 'font-anonymice-powerline'
cask 'font-clear-sans'
cask 'font-dejavu-sans'
cask 'font-dejavu-sans-mono-for-powerline'
cask 'font-droid-sans-mono-for-powerline'
cask 'font-fira-mono-for-powerline'
cask 'font-fontawesome'
cask 'font-inconsolata-dz-for-powerline'
cask 'font-inconsolata-for-powerline'
cask 'font-inconsolata-for-powerline-bold'
cask 'font-menlo-for-powerline'
cask 'font-meslo-for-powerline'
cask 'font-office-code-pro'
cask 'font-open-sans'
cask 'font-open-sans-condensed'
cask 'font-source-code-pro-for-powerline'
cask 'font-terminus'
cask 'font-ubuntu'
cask 'font-ubuntu-mono-derivative-powerline'
cask 'font-xkcd'

# Work Apps
cask 'atom'
cask 'bbedit'
cask 'chromedriver'
cask 'cyberduck'
cask 'dash'
cask 'docker'
cask 'drawio'
cask 'fork'
cask 'github'
cask 'google-cloud-sdk'
cask 'hex-fiend'
cask 'insomnia'
cask 'java'
cask 'kaleidoscope'
cask 'licecap'
cask 'microsoft-teams'
cask 'paw'
cask 'postico'
cask 'postman'
cask 'robo-3t'
cask 'rowanj-gitx'
cask 'sequel-pro-nightly'
cask 'slack'
cask 'transmit'
cask 'vagrant'
cask 'virtualbox'
cask 'visual-studio-code'

# noct
if hostname == 'noct'
  brew 'ffmpeg', args: %w[
    with-fdk-aac
    with-libass
    with-librsvg
    with-libsoxr
    with-libssh
    with-libvidstab
    with-openh264
    with-openssl
    with-rubberband
    with-srt
    with-tesseract
    with-webp
  ]
  brew 'get_iplayer'

  brew 'blueutil'
  brew 'circleci'
  brew 'kubernetes-cli'
  brew 'kubernetes-helm'
  brew 'mariadb'

  brew 'grafana'
  brew 'node_exporter'
  brew 'prometheus'

  cask '4k-video-downloader'
  cask 'adobe-creative-cloud'
  cask 'aegisub'
  cask 'android-file-transfer'
  cask 'android-platform-tools'
  cask 'audio-hijack'
  cask 'authy'
  cask 'autodmg'
  cask 'avidemux'
  cask 'balenaetcher'
  cask 'boom-3d'
  cask 'calibre'
  cask 'chicken'
  cask 'deluge'
  cask 'discord'
  cask 'dropbox'
  cask 'epic-games'
  cask 'evernote'
  cask 'filebot'
  cask 'get-iplayer-automator'
  cask 'gog-galaxy'
  cask 'google-photos-backup-and-sync'
  cask 'hackety-hack'
  cask 'handbrake'
  cask 'irccloud'
  cask 'istumbler'
  cask 'keybase'
  cask 'little-snitch'
  cask 'makemkv'
  cask 'messenger'
  cask 'micro-snitch'
  cask 'mkvtoolnix'
  cask 'monodraw'
  cask 'muzzle'
  cask 'omnigraffle'
  cask 'openemu'
  cask 'parallels'
  cask 'peakhour'
  cask 'plex'
  cask 'plex-media-player'
  cask 'pocket-casts'
  cask 'qlcolorcode'
  cask 'qlimagesize'
  cask 'qlmarkdown'
  cask 'qlprettypatch'
  cask 'qlstephen'
  cask 'qlvideo'
  cask 'quicklook-csv'
  cask 'quicklook-json'
  cask 'quicklookapk'
  cask 'rclone-browser'
  cask 'ring'
  cask 'scroll-reverser'
  cask 'sixtyforce'
  cask 'skitch'
  cask 'skyfonts'
  cask 'skype'
  cask 'spotify'
  cask 'steam'
  cask 'suspicious-package'
  cask 'teamviewer'
  cask 'trailer'
  cask 'transmission'
  cask 'virtualc64'
  cask 'viscosity'
  cask 'vmware-fusion'
  cask 'vnc-viewer'
  cask 'wavebox'
  cask 'webpquicklook'
  cask 'whatsapp'
  cask 'xld'
  cask 'zoomus'

  cask 'basictex'
  FileUtils.ln_s(
    Dir.glob('/usr/local/texlive/*basic/bin/*/pdflatex').max,
    '/usr/local/bin/pdflatex',
    force: true
  )

  mas 'Apple Remote Desktop', id: 409_907_375
  mas 'Awaken', id: 404_221_531
  mas 'Bear', id: 1_091_189_122
  mas 'HTTP Client', id: 418_138_339
  mas 'HiddenMe', id: 467_040_476
  mas 'Medis', id: 1_063_631_769
  mas 'Microsoft Remote Desktop 10', id: 1_295_203_466
  mas 'MindNode', id: 1_289_197_285
  mas 'Pocket', id: 568_494_494
  mas 'Reeder 3', id: 880_001_334
  mas 'Textual 7', id: 1_262_957_439
  mas 'Things 3', id: 904_280_696
  mas 'WireGuard', id: 1_451_685_025
  mas 'feedly', id: 865_500_966
end

if hostname == 'UAC00013'
  brew 'gnu-getopt'
  brew 'mariadb@10.0'
  brew 'packer'
  brew 'skopeo'
  brew 'sops'

  mas 'HiddenMe', id: 467_040_476
  mas 'Microsoft Remote Desktop 8', id: 715_768_417
  mas 'Microsoft Remote Desktop 10', id: 1_295_203_466
end
