# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

bindkey -e

bindkey '^K'   kill-whole-line                      # ctrl-k
bindkey '^R'   history-incremental-search-backward  # ctrl-r
bindkey '^A'   beginning-of-line                    # ctrl-a
bindkey '^E'   end-of-line                          # ctrl-e
bindkey '^D'   delete-char                          # ctrl-d
bindkey '^F'   forward-char                         # ctrl-f
bindkey '^B'   backward-char                        # ctrl-b
bindkey '^[[A' history-substring-search-up          # up
bindkey '^[[B' history-substring-search-down        # down
zle -N insert-sudo insert_sudo
bindkey "^X" insert-sudo

