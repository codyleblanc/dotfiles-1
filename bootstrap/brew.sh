#!/bin/sh

export PATH=/usr/local/bin:$PATH
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

which -s brew
if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

# Update brew and upgrade already install packages
brew update
brew upgrade

brew install bash \
             brew-cask \
             coreutils \
             ctags \
             direnv \
             findutils \
             git \
             git-extras \
             go \
             imagesnap \
             node \
             openssl \
             python \
             python3 \
             rbenv \
             readline \
             reattach-to-user-namespace \
             the_silver_searcher \
             vim \
             wget --enable-iri \
             zsh \
             z

brew cleanup

# Reminders
echo ""
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

###############################################################################
################################## FUNCTIONS ##################################
###############################################################################
