# /bin/sh
[[ `uname -s` == 'Darwin' ]] || exit 0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up OSX"
$DIR/osx.sh

echo "Installing packages"
$DIR/brew.sh