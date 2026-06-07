#!/usr/bin/env bash
# scripts/update_readme.sh - Update README.md topic and skill tables
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
README="$DOTFILES_DIR/README.md"
TOPICS_DIR="$DOTFILES_DIR/topics"
SKILLS_DIR="$DOTFILES_DIR/skills"

TMP="$(mktemp "$README.XXXXXX")"
trap 'rm -f "$TMP"' EXIT

# Replace content between <!-- TAG_START --> and <!-- TAG_END --> markers
replace_section() {
    local file="$1" tag="$2" content="$3"
    local start="<!-- ${tag}_START -->" end="<!-- ${tag}_END -->"

    if ! grep -q "$start" "$file" || ! grep -q "$end" "$file"; then
        echo "Error: markers $start / $end not found in $file" >&2
        exit 1
    fi

    {
        sed -n "1,/$start/p" "$file"
        printf '%s\n' "$content"
        sed -n "/$end/,\$p" "$file"
    } > "$TMP"
    mv "$TMP" "$file"
    TMP="$(mktemp "$README.XXXXXX")"
}

has_files() { compgen -G "$1" >/dev/null 2>&1; }

# -- Topics table --
topics_table() {
    printf '| Topic | Installs |\n'
    printf '| :--- | :--- |\n'

    for topic_path in "$TOPICS_DIR"/*/; do
        [[ -d "$topic_path" ]] || continue
        local topic
        topic="$(basename "$topic_path")"

        local parts=()

        # Brew packages
        if [[ -f "$topic_path/Brewfile" ]]; then
            local pkgs
            pkgs=$(grep -E '^(brew|cask)' "$topic_path/Brewfile" | sed -E 's/^(brew|cask) "//; s/".*//' | paste -sd ',' - | sed 's/,/, /g')
            [[ -n "$pkgs" ]] && parts+=("$pkgs")
        fi

        # Symlinks
        if has_files "$topic_path/*.symlink"; then
            local links=()
            for f in "$topic_path"/*.symlink; do
                links+=("\`$(basename "$f" .symlink)\`")
            done
            parts+=("$(IFS=', '; echo "${links[*]}")")
        fi

        # Zsh files
        if has_files "$topic_path/*.zsh"; then
            local zsh_files=()
            for f in "$topic_path"/*.zsh; do
                zsh_files+=("\`$(basename "$f")\`")
            done
            parts+=("$(IFS=', '; echo "${zsh_files[*]}")")
        fi

        local installs=""
        [[ ${#parts[@]} -gt 0 ]] && installs=$(IFS='|'; printf '%s' "${parts[*]}" | sed 's/|/ · /g')

        printf '| **%s** | %s |\n' "$topic" "$installs"
    done
}

# -- Skills table --
skills_table() {
    printf '| Skill | Description |\n'
    printf '| :--- | :--- |\n'

    [[ -d "$SKILLS_DIR" ]] || return

    for skill_dir in "$SKILLS_DIR"/*/; do
        [[ -d "$skill_dir" ]] || continue
        local skill_md="$skill_dir/SKILL.md"
        [[ -f "$skill_md" ]] || continue

        local name description
        name="$(basename "$skill_dir")"
        description=$(awk '
            /^---$/ { if(f) exit; f=1; next }
            f && /^description:/ { d=1; next }
            d && (/^[a-z]/ || /^---$/ || /^$/) { exit }
            d { print }
        ' "$skill_md" | sed 's/^ *//; s/^>- //' | tr '\n' ' ' | sed 's/  */ /g; s/^ *//; s/ *$//')

        printf '| `%s` | %s |\n' "$name" "$description"
    done
}

replace_section "$README" "TOPICS" "$(topics_table)"
replace_section "$README" "SKILLS" "$(skills_table)"

echo "README.md updated."
