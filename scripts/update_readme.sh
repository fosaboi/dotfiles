#!/usr/bin/env bash
# scripts/update_readme.sh - Automatically updates README.md with tables of dotfile topics and skills

# Get dotfiles root
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
README="$DOTFILES_DIR/README.md"
TOPICS_DIR="$DOTFILES_DIR/topics"
SKILLS_DIR="$DOTFILES_DIR/skills"

# Check if markers exist in README
if ! grep -q "<!-- TOPICS_START -->" "$README" || ! grep -q "<!-- TOPICS_END -->" "$README"; then
    echo "Error: markers <!-- TOPICS_START --> and <!-- TOPICS_END --> not found in $README"
    exit 1
fi
if ! grep -q "<!-- SKILLS_START -->" "$README" || ! grep -q "<!-- SKILLS_END -->" "$README"; then
    echo "Error: markers <!-- SKILLS_START --> and <!-- SKILLS_END --> not found in $README"
    exit 1
fi

# Generate the table header
TABLE="| Topic | Features | Tools/Apps |\n| :--- | :--- | :--- |"

# Iterate through topics
for topic in $(ls "$TOPICS_DIR" | sort); do
    TOPIC_PATH="$TOPICS_DIR/$topic"
    [[ -d "$TOPIC_PATH" ]] || continue

    FEATURES=""
    TOOLS=""

    # Detect features
    [[ -f "$TOPIC_PATH/Brewfile" ]] && FEATURES="$FEATURES 📦 Brew"
    [[ -n $(ls "$TOPIC_PATH"/*.zsh 2>/dev/null) ]] && FEATURES="$FEATURES 🐚 Zsh"
    [[ -n $(ls "$TOPIC_PATH"/*.symlink 2>/dev/null) ]] && FEATURES="$FEATURES 🔗 Link"

    # Extract tools from Brewfile
    if [[ -f "$TOPIC_PATH/Brewfile" ]]; then
        # Get up to 5 items, removing quotes and 'brew ' or 'cask '
        TOOLS=$(grep -E '^(brew|cask)' "$TOPIC_PATH/Brewfile" | head -n 5 | sed -E "s/^(brew|cask) //; s/\"//g" | paste -sd "," - | sed 's/,/, /g')
        [[ $(grep -E '^(brew|cask)' "$TOPIC_PATH/Brewfile" | wc -l) -gt 5 ]] && TOOLS="$TOOLS, ..."
    else
        # Fallback to key aliases or files
        [[ -f "$TOPIC_PATH/aliases.zsh" ]] && TOOLS="Aliases"
        [[ -n $(ls "$TOPIC_PATH"/*.symlink 2>/dev/null) ]] && TOOLS="Config"
    fi

    # Append row
    TABLE="$TABLE\n| **$topic** | $FEATURES | $TOOLS |"
done

# Generate skills table
SKILLS_TABLE="| Skill | Description |\n| :--- | :--- |"

if [[ -d "$SKILLS_DIR" ]]; then
    for skill_dir in "$SKILLS_DIR"/*/; do
        [[ -d "$skill_dir" ]] || continue
        SKILL_MD="$skill_dir/SKILL.md"
        [[ -f "$SKILL_MD" ]] || continue

        # Extract name and description from YAML frontmatter (first block only)
        NAME=$(awk '/^---$/{if(found) exit; found=1; next} found && /^name:/{sub(/^name: */, ""); print; exit}' "$SKILL_MD")
        
        # Extract description - get lines after 'description:' in first block only
        DESCRIPTION=$(awk '
        /^---$/{if(found) exit; found=1; next}
        found && /^description:/{desc=1; next}
        desc && /^---$/{exit}
        desc && /^$/{exit}
        desc{print}
        ' "$SKILL_MD" | sed 's/^ *//;s/^>- //;s/^ *//' | tr '\n' ' ' | sed 's/  */ /g; s/^ *//; s/ *$//')

        SKILLS_TABLE="$SKILLS_TABLE\n| **$NAME** | $DESCRIPTION |"
    done
fi

# Use temporary files for safely replacing the content
START_MARKER="<!-- TOPICS_START -->"
END_MARKER="<!-- TOPICS_END -->"

# Replace topics table
{
    sed -n "1,/$START_MARKER/p" "$README"
    echo -e "$TABLE"
    sed -n "/$END_MARKER/,\$p" "$README"
} > "$README.tmp"

# Replace skills table
START_MARKER="<!-- SKILLS_START -->"
END_MARKER="<!-- SKILLS_END -->"
{
    sed -n "1,/$START_MARKER/p" "$README.tmp"
    echo -e "$SKILLS_TABLE"
    sed -n "/$END_MARKER/,\$p" "$README.tmp"
} > "$README.tmp2"

mv "$README.tmp2" "$README"
rm -f "$README.tmp"
echo "✅ README.md updated."
