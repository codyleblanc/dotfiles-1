# Setup terminal, and turn on colors
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='less'
export EDITOR='vim'
export KEYTIMEOUT=1

# Set LC_ALL="UTF8"
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

# Go Paths
export GOPATH=$HOME/Developer/Go
export GOROOT=/usr/local/Cellar/go/1.2.1/libexec

# MVim needs to know where macvim is
export VIM_APP_DIR=/usr/local/Cellar/macvim/HEAD

# Mark path
export MARKPATH=$HOME/.marks

# Setup Path
PATH=/usr/local/bin:$PATH                          # Brew path
PATH=/usr/local/sbin:$PATH                         # Brew path
PATH=/usr/local/share/npm/bin:$PATH                # Node path
PATH=/usr/local/Cellar/go/1.2.1/libexec/bin:$PATH  # Go Exec Path
PATH=$GOPATH/bin:$PATH                             # Go Bin Path

# remove duplicate entries
typeset -U PATH
export PATH
