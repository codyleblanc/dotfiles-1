#!/bin/sh

# Variables
# =========
export DOTDIR="${HOME}/Development/Dotfiles"
local REPO="https://github.com/codyleblanc/dots.git"

# Directory setup
# ===============
pushd .
mkdir -p $DOTDIR
cd $DOTDIR
echo "Changing directory to ${DOTDIR}"

# Clone down the dotfiles if not already
if [ ! -d ".git" ]; then
    echo "Cloning ${REPO}"
    git clone --recursive $REPO .
else
    echo "Pulling ${REPO}"
    git pull --recurse-submodules
fi

# Symlink them
# ============
ln -siv     $DOTDIR/zsh/zshrc               $HOME/.zshrc        # ZSH
ln -siv     $DOTDIR/sourcecontrol/gitconfig $HOME/.gitconfig    # GIT
ln -sFiv    $DOTDIR/sourcecontrol/git       $HOME/.git          # GITDIR
#ln -siv     $DOTDIR/vimrc                   $HOME/.vimrc        # VIM

# Git Setup
# =========
echo "Checking for SSH key, generating one if it does not exist..."
[[ -f "${HOME}/.ssh/id_rsa.pub" ]] || ssh-keygen -t rsa

echo "Copying public key to clipboard. Paste it into your Github account..."
[[ -f "${HOME}/.ssh/id_rsa.pub" ]] && cat "${HOME}/.ssh/id_rsa.pub" | pbcopy
open "https://github.com/account/ssh"

# OSX Setup
# =========
if [ `uname -s` == 'Darwin' ] ; then
    echo "Setting up OSX"
    $DOTDIR/bootstrap/osx.sh

    echo "Installing brew and packages"
    $DOTDIR/bootstrap/brew.sh
fi

# Linux Setup
# ===========
if [ `uname -s` == 'Linux' ] ; then
    echo "Nothing to do for linux at the moment."
fi

# Change the shell to ZSH
ZSH="$( which zsh )"
if [ -n "$ZSH" ]; then
    echo "Changing shell to $ZSH"
    chsh -s $ZSH
fi