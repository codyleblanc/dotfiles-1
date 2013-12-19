#!/bin/sh

# Make sure brew is on the path
export PATH=/usr/local/bin:$PATH

# Install brew if needed
which -s brew
if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

# Update brew and upgrade already install packages
brew update
brew upgrade

# Install all listed in the package list file
cat $PACKAGELIST | while read package
do
    echo "\nINSTALLING PACKAGE: ${package}"
    brew install $package
done

# Clean up the old packages
brew cleanup

# Reminders
echo ""
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."