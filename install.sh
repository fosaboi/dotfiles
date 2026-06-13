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

# -- Logging Helpers --
log_ok()      { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
log_warn()    { printf "  ${YELLOW}⚠${RESET} %s\n" "$1"; }
log_error()   { printf "  ${RED}✗${RESET} %s\n" "$1"; }
log_info()    { printf "  ${DIM}%s${RESET}\n" "$1"; }
log_header()  { printf "\n${BOLD}${BLUE}=== %s ===${RESET}\n" "$1"; }
log_step()    { printf "  ${CYAN}➜${RESET} %s...\n" "$1"; }

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TOPICS_DIR="$DOTFILES_DIR/topics"

# Add Homebrew to PATH if it exists but is not currently in PATH
if ! command -v brew &>/dev/null; then
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

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
get_symlink_target() {
    local filename="$1"
    case "$filename" in
        "starship.toml.symlink") echo "$HOME/.config/starship.toml" ;;
        "zshrc.symlink") echo "$HOME/.zshrc" ;;
        "gitconfig.symlink") echo "$HOME/.gitconfig" ;;
        "gitignore_global.symlink") echo "$HOME/.gitignore_global" ;;
        *) echo "$HOME/.$(basename "$filename" .symlink)" ;;
    esac
}

INSTALLED_TOPICS=()
SKIPPED_TOPICS=()
FAILED_BREW_TOPICS=()
LINKED_FILES=()
BREW_INSTALLED=0

link_file() {
    local src="$1" dst="$2"
    local filename="$(basename "$src")"
    local short="${dst/#$HOME/~}"

    # For files that support import/includes, bootstrap a local file instead of symlinking
    if [[ "$filename" == "zshrc.symlink" || "$filename" == "gitconfig.symlink" ]]; then
        if [[ -L "$dst" ]]; then
            rm -f "$dst" # Remove existing symlink if it is one
        fi

        local include_line
        local file_header
        if [[ "$filename" == "zshrc.symlink" ]]; then
            include_line="source \"$src\""
            file_header="# Source generic dotfiles configuration\nsource \"%s\"\n\n# Local configurations/app installations can be added below:\n"
        else
            include_line="path = $src"
            file_header="[include]\n    path = %s\n\n# Local configurations can be added below:\n"
        fi

        if [[ ! -f "$dst" ]]; then
            mkdir -p "$(dirname "$dst")"
            printf "$file_header" "$src" > "$dst"
            LINKED_FILES+=("$dst")
            log_ok "Bootstrapped physical $short loader (protected from local writes)"
        else
            # If it exists, make sure it includes/sources our dotfile
            if ! grep -Fq "$include_line" "$dst"; then
                local tmp_file
                tmp_file=$(mktemp)
                if [[ "$filename" == "zshrc.symlink" ]]; then
                    printf "source \"%s\"\n" "$src" > "$tmp_file"
                else
                    printf "[include]\n    path = %s\n" "$src" > "$tmp_file"
                fi
                cat "$dst" >> "$tmp_file"
                mv "$tmp_file" "$dst"
                log_ok "Prepended loader directive to existing $short"
            else
                log_info "  $short already bootstrapped"
            fi
        fi
        return 0
    fi

    # Normal symlink behavior for other files
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        log_warn "$short exists (not a symlink) - skipped"
        return 1
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    LINKED_FILES+=("$dst")
    log_ok "Symlinked $short"
}

install_topic() {
    local topic="$1" path="$TOPICS_DIR/$topic"
    if [[ ! -d "$path" ]]; then
        log_warn "Topic '$topic' not found - skipped"
        SKIPPED_TOPICS+=("$topic")
        return 1
    fi

    # Check if there's anything to do (Brewfile or symlinks)
    local has_brew=0
    [[ -f "$path/Brewfile" ]] && has_brew=1

    local has_symlinks=0
    local symlink_files=()
    while read -r file; do
        if [[ -n "$file" ]]; then
            symlink_files+=("$file")
            has_symlinks=1
        fi
    done < <(find "$path" -name "*.symlink" 2>/dev/null)

    # If nothing to install or link, we log that it's skipped/empty and return
    if [[ $has_brew -eq 0 && $has_symlinks -eq 0 ]]; then
        return 0
    fi

    log_header "Installing Topic: $topic"

    # Install packages (macOS only)
    if [[ $has_brew -eq 1 ]]; then
        if [[ "$(uname)" != Darwin ]]; then
            log_warn "Skipping packages: Brewfile is macOS only"
        else
            log_step "Running Homebrew bundle"
            if ! command -v brew &>/dev/null; then
                log_error "Homebrew is not installed. Cannot run Brewfile."
                FAILED_BREW_TOPICS+=("$topic")
            else
                local tmp_out
                tmp_out=$(mktemp)
                # Run brew bundle in verbose mode to log every dependency status
                if brew bundle --file="$path/Brewfile" --verbose >"$tmp_out" 2>&1; then
                    while read -r line; do
                        log_info "    $line"
                    done < "$tmp_out"
                    log_ok "Brewfile packages configured successfully"
                    BREW_INSTALLED=1
                else
                    while read -r line; do
                        log_info "    $line"
                    done < "$tmp_out"
                    log_error "Brewfile packages installation failed"
                    FAILED_BREW_TOPICS+=("$topic")
                fi
                rm -f "$tmp_out"
            fi
        fi
    fi

    # Create symlinks
    if [[ $has_symlinks -eq 1 ]]; then
        log_step "Creating symlinks"
        for file in "${symlink_files[@]}"; do
            local filename="$(basename "$file")"
            local target="$(get_symlink_target "$filename")"
            link_file "$file" "$target"
        done
    fi

    INSTALLED_TOPICS+=("$topic")
}

log_header "Starting Dotfiles Installation"
printf "  ${DIM}%d topics to process: %s${RESET}\n\n" "${#SELECTED_TOPICS[@]}" "${SELECTED_TOPICS[*]}"

for topic in "${SELECTED_TOPICS[@]}"; do
    install_topic "$topic"
done

# Link skills
link_skills() {
    log_header "Linking Skills"
    if [[ ! -d "$DOTFILES_DIR/skills" ]]; then
        log_info "No skills directory found"
        return
    fi

    mkdir -p "$HOME/.agents/skills"
    local count=0
    while read -r dir; do
        local skill_name="$(basename "$dir")"
        if [[ -e "$HOME/.agents/skills/$skill_name" && ! -L "$HOME/.agents/skills/$skill_name" ]]; then
            log_warn "$skill_name exists (not a symlink) - skipped"
        else
            ln -sfn "$dir" "$HOME/.agents/skills/$skill_name"
            log_ok "Linked skill: $skill_name"
            ((count++)) || true
        fi
    done < <(find "$DOTFILES_DIR/skills" -maxdepth 1 -mindepth 1 -type d)

    if [[ $count -eq 0 ]]; then
        log_info "No skills to link"
    fi
}

link_skills

# Summary
log_header "Installation Summary"
printf "  ${GREEN}✓${RESET} ${BOLD}%d${RESET} topics processed\n" "${#INSTALLED_TOPICS[@]}"
printf "  ${GREEN}✓${RESET} ${BOLD}%d${RESET} symlinks created\n" "${#LINKED_FILES[@]}"
printf "  ${GREEN}✓${RESET} ${BOLD}%d${RESET} skills linked\n" "$(find "$HOME/.agents/skills" -maxdepth 1 -type l 2>/dev/null | wc -l | tr -d ' ')"

if [[ ${#SKIPPED_TOPICS[@]} -gt 0 ]]; then
    printf "  ${YELLOW}⚠${RESET} ${BOLD}%d${RESET} topics skipped: %s\n" "${#SKIPPED_TOPICS[@]}" "${SKIPPED_TOPICS[*]}"
fi
echo ""

if [[ ${#FAILED_BREW_TOPICS[@]} -gt 0 ]]; then
    log_header "Brew Bundle Failures"
    for t in "${FAILED_BREW_TOPICS[@]}"; do
        log_warn "Topic '$t' brew installation failed. To debug, run:"
        log_info "  brew bundle --file=\"$TOPICS_DIR/$t/Brewfile\""
    done
    echo ""
fi
