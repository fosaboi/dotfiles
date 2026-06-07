#!/usr/bin/env bash
# Dotfiles Installer
set -e

# -- Colors --
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'

ok()   { printf "  ${GREEN}*${RESET} %s\n" "$1"; }
warn() { printf "  ${YELLOW}!${RESET} %s\n" "$1"; }
info() { printf "  ${DIM}%s${RESET}\n" "$1"; }
header() { printf "\n${BOLD}${BLUE}%s${RESET}\n" "$1"; }

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TOPICS_DIR="$DOTFILES_DIR/topics"

# Default to all topics if none specified
if [[ $# -eq 0 ]]; then
    SELECTED_TOPICS=()
    for d in "$TOPICS_DIR"/*/; do
        [[ -d "$d" ]] && SELECTED_TOPICS+=("$(basename "$d")")
    done
else
    SELECTED_TOPICS=("$@")
fi

# Symlink targets: filename -> destination
declare -A SYMLINK_MAP=(
    ["starship.toml.symlink"]="$HOME/.config/starship.toml"
    ["zshrc.symlink"]="$HOME/.zshrc"
    ["gitconfig.symlink"]="$HOME/.gitconfig"
    ["gitignore_global.symlink"]="$HOME/.gitignore_global"
)

INSTALLED_TOPICS=()
SKIPPED_TOPICS=()
LINKED_FILES=()
BREW_INSTALLED=0

link_file() {
    local src="$1" dst="$2"
    local short="${dst/#$HOME/~}"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        warn "$short exists (not a symlink) - skipped"
        return 1
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    LINKED_FILES+=("$dst")
    ok "$short"
}

install_topic() {
    local topic="$1" path="$TOPICS_DIR/$topic"
    if [[ ! -d "$path" ]]; then
        warn "Topic '$topic' not found - skipped"
        SKIPPED_TOPICS+=("$topic")
        return 1
    fi

    printf "${CYAN}  %-14s${RESET}" "$topic"

    # Install packages (macOS only)
    local brew_ok=""
    if [[ "$(uname)" == Darwin && -f "$path/Brewfile" ]]; then
        if brew bundle --file="$path/Brewfile" --quiet &>/dev/null; then
            brew_ok="brew"
            BREW_INSTALLED=1
        else
            brew_ok="brew!"
        fi
    fi

    # Create symlinks
    local symlink_count=0
    while read -r file; do
        local filename="$(basename "$file")"
        local target="${SYMLINK_MAP[$filename]:-$HOME/.$(basename "$file" .symlink)}"
        if link_file "$file" "$target" 2>/dev/null; then
            ((symlink_count++)) || true
        fi
    done < <(find "$path" -name "*.symlink")

    # Status line
    local parts=()
    [[ -n "$brew_ok" && "$brew_ok" == "brew" ]] && parts+=("${GREEN}brew${RESET}")
    [[ -n "$brew_ok" && "$brew_ok" == "brew!" ]] && parts+=("${RED}brew failed${RESET}")
    [[ $symlink_count -gt 0 ]] && parts+=("${GREEN}${symlink_count} linked${RESET}")

    if [[ ${#parts[@]} -gt 0 ]]; then
        printf "%b\n" "$(IFS=', '; echo "${parts[*]}")"
    else
        printf "${DIM}ok${RESET}\n"
    fi

    INSTALLED_TOPICS+=("$topic")
}

header "Dotfiles"
printf "  ${DIM}%d topics: %s${RESET}\n" "${#SELECTED_TOPICS[@]}" "${SELECTED_TOPICS[*]}"
echo ""

for topic in "${SELECTED_TOPICS[@]}"; do
    install_topic "$topic"
done

# Link skills
link_skills() {
    header "Skills"
    if [[ ! -d "$DOTFILES_DIR/skills" ]]; then
        info "No skills directory found"
        return
    fi

    mkdir -p "$HOME/.agents/skills"
    local count=0
    while read -r dir; do
        local skill_name="$(basename "$dir")"
        if [[ -e "$HOME/.agents/skills/$skill_name" && ! -L "$HOME/.agents/skills/$skill_name" ]]; then
            warn "$skill_name exists (not a symlink) - skipped"
        else
            ln -sfn "$dir" "$HOME/.agents/skills/$skill_name"
            ((count++)) || true
        fi
    done < <(find "$DOTFILES_DIR/skills" -maxdepth 1 -mindepth 1 -type d)

    if [[ $count -gt 0 ]]; then
        ok "$count skills linked"
    else
        info "No skills to link"
    fi
}

link_skills

# Summary
header "Done"
printf "  ${GREEN}%d${RESET} topics  ${GREEN}%d${RESET} symlinks  ${GREEN}%d${RESET} skills\n" \
    "${#INSTALLED_TOPICS[@]}" "${#LINKED_FILES[@]}" "$(find "$HOME/.agents/skills" -maxdepth 1 -type l 2>/dev/null | wc -l | tr -d ' ')"
[[ ${#SKIPPED_TOPICS[@]} -gt 0 ]] && printf "  ${YELLOW}%d skipped${RESET}: %s\n" "${#SKIPPED_TOPICS[@]}" "${SKIPPED_TOPICS[*]}"
echo ""
