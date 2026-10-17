# dotfiles

Personal dotfiles for macOS and Fedora. Includes Neovim, Kitty, Zsh, and Git config.

## What's included

- **nvim** — [LazyVim](https://lazyvim.org) with configs for Python, Ruby, Rust, SQL
- **kitty** — Catppuccin Mocha theme, FiraCode Nerd Font
- **zsh** — oh-my-zsh, pyenv, rbenv, direnv
- **git** — global gitconfig, difftastic as difftool
- **Brewfile** — all personal tooling (macOS)
- **packages-fedora.txt** — the same tooling via dnf (Fedora); Lazy* tools and the Nerd Font are fetched from their GitHub releases

## Fresh install

```bash
git clone https://github.com/mau5mat/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

Existing configs are moved to `<file>.bak.<timestamp>` before being symlinked.

## Machine-specific config

`~/.zshrc.local` and `~/.secrets` are sourced if present and not tracked. For example, on the Mac:

```bash
export DEV_DIR="$HOME/Development"
```

## Manual steps after install

- **Ruby**: `rbenv install <version>` then `rbenv global <version>`
- **Python**: on Fedora, first `git clone https://github.com/pyenv/pyenv ~/.pyenv`; then `pyenv install <version>` and `pyenv global <version>`
- **Rust**: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- **Haskell**: on Fedora, first install ghcup with `curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh`; then `ghcup tui` to install GHC + Cabal, and install `haskell-language-server` via Mason in Neovim
- **Neovim**: launch and run `:Lazy` to install plugins, then `:TSInstall all` for treesitter parsers
