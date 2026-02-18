# dotfiles

Personal dotfiles for macOS. Includes Neovim, Kitty, Zsh, and Git config.

## What's included

- **nvim** — [LazyVim](https://lazyvim.org) with configs for Python, Ruby, Rust, SQL
- **kitty** — Catppuccin Mocha theme, FiraCode Nerd Font
- **zsh** — oh-my-zsh, pyenv, rbenv
- **git** — global gitconfig
- **Brewfile** — all personal tooling

## Fresh install

```bash
git clone https://github.com/mau5mat/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

## Manual steps after install

- **Ruby**: `rbenv install <version>` then `rbenv global <version>`
- **Python**: `pyenv install <version>` then `pyenv global <version>`
- **Rust**: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- **Neovim**: launch and run `:Lazy` to install plugins, then `:TSInstall all` for treesitter parsers
