# Obsidian CLI integration
# To use these, enable "Command line interface" in Obsidian Settings > General

# Quick append to today's daily note
# Usage: log "Your note here"
log() {
  if command -v obsidian >/dev/null 2>&1; then
    # We prepend the current time for easier logging
    obsidian daily:append content="- $(date +'%H:%M') $1"
  else
    echo "⚠️ 'obsidian' command not found."
    echo "Please enable it in: Obsidian Settings > General > Command line interface"
  fi
}

# Open today's daily note in Obsidian
alias daily='obsidian daily'
