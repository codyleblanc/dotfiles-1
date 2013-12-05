# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey -v   # Default to standard vi bindings, regardless of editor string
