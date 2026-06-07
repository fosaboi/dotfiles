# dotfiles

## Setup

```bash
git clone <repo-url> ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

This installs packages (Homebrew) and symlinks configs to `$HOME`. 
For a minimal install, you can pass specific topics to `./install.sh`:

```bash
./install.sh core git zsh
```

## Topics

<!-- TOPICS_START -->
| Topic | Features | Tools/Apps |
| :--- | :--- | :--- |
| **apps** |  📦 Brew | zed, obsidian |
| **core** |  📦 Brew 🐚 Zsh | git, gh, fzf, lazygit, ripgrep, ... |
| **git** |  🐚 Zsh 🔗 Link | Config |
| **obsidian** |  🐚 Zsh | Aliases |
| **python** |  📦 Brew 🐚 Zsh | uv, pre-commit |
| **starship** |  🔗 Link | Config |
| **zsh** |  🐚 Zsh 🔗 Link | Config |
<!-- TOPICS_END -->

## Skills

<!-- SKILLS_START -->
| Skill | Description |
| :--- | :--- |
| **async-safety** | Prevent race conditions, memory leaks, and stale state in async operations. Triggers on: "async", "race condition", "cleanup", "abort", "useEffect" |
| **data-integrity** | Prevent data corruption through defensive programming. Guards against null values, division by zero, and type mismatches. Triggers on: "null safety", "data validation", "defensive", "guard" |
| **error-handling** | Handle failures explicitly and observably. Distinguish error states from empty states. Surface all failures. Triggers on: "error", "exception", "catch", "status check", "http error" |
| **skills-how-to** | Guide for creating concise, clear, and straightforward SKILL.md files. Skills must be concise, clear, and straightforward. Use when creating or reviewing skills. Triggers on: "create a skill", "write SKILL.md". |
| **databases** | Efficient and safe database query patterns. Push filters to DB, avoid full table loads, guard against NULL. Triggers on: "SQL", "query", "database", "filter", "table" |
| **fetching** | Safe data fetching patterns for HTTP and API requests. Always validate, always handle errors, always allow cancellation. Triggers on: "fetch", "HTTP", "API", "request", "axios" |
<!-- SKILLS_END -->

## Adding a topic

1. Create a new directory in `topics/`
2. Add a `Brewfile`, `*.zsh`, or `*.symlink`
3. Run `./scripts/update_readme.sh` to update this documentation
