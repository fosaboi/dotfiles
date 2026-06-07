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
| Topic | Installs |
| :--- | :--- |
| **apps** | zed, obsidian |
| **core** | git, gh, fzf, lazygit, ripgrep, fd, bat, eza, zoxide, jq, yq, direnv, tldr, htop, starship · `aliases.zsh`,`path.zsh` |
| **git** | `gitconfig`,`gitignore_global` · `aliases.zsh` |
| **obsidian** | `aliases.zsh` |
| **python** | uv, pre-commit · `setup.zsh` |
| **starship** | `starship.toml` |
| **zsh** | `zshrc` · `completion.zsh` |
<!-- TOPICS_END -->

## Skills

<!-- SKILLS_START -->
| Skill | Description |
| :--- | :--- |
| `core-async-safety` | Prevent race conditions, memory leaks, and stale state in async operations. Triggers on: "async", "race condition", "cleanup", "abort", "useEffect" |
| `core-data-integrity` | Prevent data corruption through defensive programming. Guards against null values, division by zero, and type mismatches. Triggers on: "null safety", "data validation", "defensive", "guard" |
| `core-error-handling` | Handle failures explicitly and observably. Distinguish error states from empty states. Surface all failures. Triggers on: "error", "exception", "catch", "status check", "http error" |
| `core-write-skills` | Guide for creating concise, clear, and straightforward SKILL.md files. Skills must be concise, clear, and straightforward. Use when creating or reviewing skills. Triggers on: "create a skill", "write SKILL.md". |
| `data-databases` | Efficient and safe database query patterns. Push filters to DB, avoid full table loads, guard against NULL. Triggers on: "SQL", "query", "database", "filter", "table" |
| `data-fetching` | Safe data fetching patterns for HTTP and API requests. Always validate, always handle errors, always allow cancellation. Triggers on: "fetch", "HTTP", "API", "request", "axios" |
<!-- SKILLS_END -->

## Adding a topic

1. Create a new directory in `topics/`
2. Add a `Brewfile`, `*.zsh`, or `*.symlink`
3. Run `./scripts/update_readme.sh` to update this documentation
