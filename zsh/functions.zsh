zsh_recompile() {
    autoload -U zrecompile
    rm -f $ZDOTS/*.zwc
    rm -f ~/.zshrc.zwc

    [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
    [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old

    for f in $ZDOTS/**/*.zsh; do
        [[ -f $f ]] && zrecompile -p $f
        [[ -f $f.zwc.old ]] && rm -f $f.zwc.old
    done

    [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
    [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old

    source ~/.zshrc
}

# -------------------------------------------------------------------
# compressed file expander
# (from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh)
# -------------------------------------------------------------------
ex() {
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.bz2) tar xvjf $1;;
            *.tar.gz) tar xvzf $1;;
            *.tar.xz) tar xvJf $1;;
            *.tar.lzma) tar --lzma xvf $1;;
            *.bz2) bunzip $1;;
            *.rar) unrar $1;;
            *.gz) gunzip $1;;
            *.tar) tar xvf $1;;
            *.tbz2) tar xvjf $1;;
            *.tgz) tar xvzf $1;;
            *.zip) unzip $1;;
            *.Z) uncompress $1;;
            *.7z) 7z x $1;;
            *.dmg) hdiutul mount $1;; # mount OS X disk images
            *) echo "'$1' cannot be extracted via >ex<";;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -------------------------------------------------------------------
# Find files and exec commands at them.
# $ find-exec .coffee cat | wc -l
# # => 9762
# from https://github.com/paulmillr/dotfiles
# -------------------------------------------------------------------
find-exec() {
    find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# -------------------------------------------------------------------
# Show how much RAM application uses.
# $ ram safari
# # => safari uses 154.69 MBs of RAM.
# from https://github.com/paulmillr/dotfiles
# -------------------------------------------------------------------
ram() {
    local sum
    local items
    local app="$1"
    if [ -z "$app" ]; then
        echo "First argument - pattern to grep from processes"
    else
        sum=0
        for i in `ps aux | grep -i "$app" | grep -v "grep" | awk '{print $6}'`; do
            sum=$(($i + $sum))
        done
        sum=$(echo "scale=2; $sum / 1024.0" | bc)
        if [[ $sum != "0" ]]; then
            echo "${fg[blue]}${app}${reset_color} uses ${fg[green]}${sum}${reset_color} MBs of RAM."
        else
            echo "There are no processes with pattern '${fg[blue]}${app}${reset_color}' are running."
        fi
    fi
}

# -------------------------------------------------------------------
# any from http://onethingwell.org/post/14669173541/any
# search for running processes
# -------------------------------------------------------------------
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}

# -------------------------------------------------------------------
# display a neatly formatted path
# -------------------------------------------------------------------
path() {
    echo $PATH | tr ":" "\n" | \
        awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
               sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
               sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
               sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
               sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
               sub(\"/.rvm\",  \"$fg_no_bold[red]/.rvm$reset_color\"); \
               print }"
}

# -------------------------------------------------------------------
# Mac specific functions
# -------------------------------------------------------------------
if [[ $IS_MAC -eq 1 ]]; then
    # view man pages in Preview
    pman() { ps=`mktemp -t manpageXXXX`.ps ; man -t $@ > "$ps" ; open "$ps" ; }

    # Remote Mount (sshfs)
    # creates mount folder and mounts the remote filesystem
    rmount() {
        local host folder mname
        host="${1%%:*}:"
        [[ ${1%:} == ${host%%:*} ]] && folder='' || folder=${1##*:}
        if [[ -n $2 ]]; then
            mname=$2
        else
            mname=${folder##*/}
            [[ "$mname" == "" ]] && mname=${host%%:*}
        fi
        if [[ $(grep -i "host ${host%%:*}" ~/.ssh/config) != '' ]]; then
            mkdir -p ~/mounts/$mname > /dev/null
            sshfs $host$folder ~/mounts/$mname -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=$mname,noappledouble && echo "mounted ~/mounts/$mname"
        else
            echo "No entry found for ${host%%:*}"
            return 1
        fi
    }

    # Remote Umount, unmounts and deletes local folder (experimental, watch you step)
    rumount() {
        if [[ $1 == "-a" ]]; then
            ls -1 ~/mounts/|while read dir
            do
                [[ -d $(mount|grep "mounts/$dir") ]] && umount ~/mounts/$dir
                [[ -d $(ls ~/mounts/$dir) ]] || rm -rf ~/mounts/$dir
            done
        else
            [[ -d $(mount|grep "mounts/$1") ]] && umount ~/mounts/$1
            [[ -d $(ls ~/mounts/$1) ]] || rm -rf ~/mounts/$1
        fi
    }

    brw() {
        if [[ -z "$1" ]]; then
            echo "Usage: brw as you would brew" >&2 ; return 1
        else
            brew "$@"

            if [ $? -eq 0 ]; then
                brew list > $PACKAGELIST
            fi
        fi
    }
fi

# -------------------------------------------------------------------
# nice mount (http://catonmat.net/blog/another-ten-one-liners-from-commandlingfu-explained)
# displays mounted drive information in a nicely formatted manner
# -------------------------------------------------------------------
nicemount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2="";1') | column -t ; }

# -------------------------------------------------------------------
# myIP address
# -------------------------------------------------------------------
myip() {
    ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
    ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

# -------------------------------------------------------------------
# console function
# -------------------------------------------------------------------
console () {
    if [[ $# > 0 ]]; then
        query=$(echo "$*"|tr -s ' ' '|')
        tail -f /var/log/system.log|grep -i --color=auto -E "$query"
    else
        tail -f /var/log/system.log
    fi
}

# -------------------------------------------------------------------
# shell to define words
# http://vikros.tumblr.com/post/23750050330/cute-little-function-time
# -------------------------------------------------------------------
givedef() {
    if [[ $# -ge 2 ]] then
        echo "givedef: too many arguments" >&2
        return 1
    else
        curl "dict://dict.org/d:$1"
    fi
}

# --------------------------------------------------------------------
# ps with a grep
# from http://hiltmon.com/blog/2013/07/30/quick-process-search/
# --------------------------------------------------------------------
psax() {
    ps auxwwwh | grep "$@" | grep -v grep
}

# --------------------------------------------------------------------
# jump/mark mostly taken from Oh my zsh plugin
# --------------------------------------------------------------------
j() {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

mark() {
    mkdir -p "$MARKPATH"
    ln -s "$(pwd)" "$MARKPATH/$1"
}

unmark() {
    rm -i "$MARKPATH/$1"
}

marks() {
    for link in $MARKPATH/*(@); do
        local markname="$fg[cyan]${link:t}$reset_color"
        local markpath="$fg[blue]$(readlink $link)$reset_color"
        printf "\t%s\t" $markname
        printf "-> %s \t\n" $markpath
    done
}

insert_sudo () {
    zle beginning-of-line; zle -U "sudo "
}
