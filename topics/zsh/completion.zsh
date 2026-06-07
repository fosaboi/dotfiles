# Zsh Completion System
autoload -Uz compinit

# Only regenerate .zcompdump once per day for speed
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Menu-driven completion
zstyle ':completion:*' menu select

# Colors in completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Group completions by category
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
