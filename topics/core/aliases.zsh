# Core Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"

# Core Tools (Modern Alternatives)
alias ls="eza --icons --group-directories-first 2>/dev/null || ls -F"
alias ll="eza -la --git --icons --group-directories-first 2>/dev/null || ls -lahF"
alias cat="bat --style=plain 2>/dev/null || cat"
alias grep="grep --color=auto"
alias df="df -h"
alias du="du -sh"
alias mkdir="mkdir -p"

# Editor

alias z="zed ."

# Knowledge capture
til() { echo "- $(date +%H:%M) $*" >> ~/Documents/daily/$(date +%Y-%m-%d).md }
