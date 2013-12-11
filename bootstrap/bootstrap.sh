#!/bin/sh

# Variables
# =========
export DOTDIR="${HOME}/Development/Dotfiles"
REPO="https://github.com/codyleblanc/dots.git"

# Utility Functions
# =================
function link_file {
    source=$1
    # strip the .symlink and everything after
    lnk=`basename $source | sed 's/\symlink_//g'`
    # prepend a "."
    lnk="$HOME/.$lnk"

    if [ -h $lnk ]; then
        old_source=`readlink $lnk`
        if [ "$old_source" != "$source" ]; then
            rm $lnk
            echo "WARN: removed legacy symlink: $lnk -> $old_source"
        fi
    elif [ -f $lnk ] || [ -d $lnk ]; then
        if [ ! -d $BACKUP_DIR ]; then
            mkdir -p $BACKUP_DIR
            echo "WARN: made backup directory $BACKUP_DIR"
        fi
        echo "WARN: moved old $lnk to $BACKUP_DIR"
        mv $lnk $BACKUP_DIR/
    fi

    [ -h $lnk ] || ln -s $source $lnk && echo "Created $lnk -> $source"
}

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
link_file $DOTDIR/zsh/zshrc                 # ZSH
link_file $DOTDIR/sourcecontrol/gitconfig   # GIT
link_file $DOTDIR/sourcecontrol/git         # GITDIR
link_file $DOTDIR/vimrc                     # VIM

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