#!/usr/bin/env bash
# Dotfiles Installer: Clean, Modular, and Robust.
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TOPICS_DIR="$DOTFILES_DIR/topics"

# Topics to install (default to all if none provided)
SELECTED_TOPICS=("$@")
if [[ ${#SELECTED_TOPICS[@]} -eq 0 ]]; then
    SELECTED_TOPICS=($(ls "$TOPICS_DIR"))
fi

echo "🚀 Installing topics: ${SELECTED_TOPICS[*]}"

# Helper for symlinking
link_file() {
    local src="$1"
    local dst="$2"
    echo "🔗 Linking $src -> $dst"
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
}

for topic in "${SELECTED_TOPICS[@]}"; do
    TOPIC_PATH="$TOPICS_DIR/$topic"
    [[ -d "$TOPIC_PATH" ]] || { echo "⚠️ Topic '$topic' not found. Skipping."; continue; }

    echo "--- Topic: $topic ---"

    # 1. Package Installation (macOS only)
    if [[ "$(uname)" == "Darwin" ]] && [[ -f "$TOPIC_PATH/Brewfile" ]]; then
        echo "📦 Bundling $topic packages..."
        brew bundle --file="$TOPIC_PATH/Brewfile"
    fi

    # 2. Automated Symlinking
    # Finds all *.symlink files and maps them:
    #   zshrc.symlink        -> ~/.zshrc
    #   starship.toml.symlink -> ~/.config/starship.toml
    #   gitconfig.symlink    -> ~/.gitconfig
    find "$TOPIC_PATH" -name "*.symlink" | while read -r symlink_file; do
        filename=$(basename "$symlink_file" .symlink)

        case "$filename" in
            "starship.toml") target="$HOME/.config/starship.toml" ;;
            "zshrc")         target="$HOME/.zshrc" ;;
            "gitconfig")     target="$HOME/.gitconfig" ;;
            "gitignore_global") target="$HOME/.gitignore_global" ;;
            *)               target="$HOME/.$filename" ;;
        esac

        link_file "$symlink_file" "$target"
    done
done

# Link Vibe skills
echo "🔧 Linking skills..."
SKILLS_DIR="$DOTFILES_DIR/skills"
AGENTS_SKILLS="$HOME/.agents/skills"

mkdir -p "$AGENTS_SKILLS"
if [[ -d "$SKILLS_DIR" ]]; then
    find "$SKILLS_DIR" -maxdepth 1 -type d ! -name "." | while read -r skill_dir; do
        skill_name=$(basename "$skill_dir")
        link_file "$skill_dir" "$AGENTS_SKILLS/$skill_name"
    done
fi

echo "✅ Done. Restart your shell."
