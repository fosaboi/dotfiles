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
| **apps** |  📦 Brew | zed, obsidian, lazygit |
| **core** |  📦 Brew 🐚 Zsh | git, gh, fzf, ripgrep, fd, ... |
| **git** |  🐚 Zsh 🔗 Link | Config |
| **obsidian** |  🐚 Zsh | Aliases |
| **python** |  📦 Brew 🐚 Zsh | uv, pre-commit |
| **starship** |  🔗 Link | Config |
| **zsh** |  🔗 Link | Config |
<!-- TOPICS_END -->

## Adding a topic

1. Create a new directory in `topics/`
2. Add a `Brewfile`, `*.zsh`, or `*.symlink`
3. Run `./scripts/update_readme.sh` to update this documentation
