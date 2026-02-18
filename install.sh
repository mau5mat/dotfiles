#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing dotfiles from $DOTFILES"

# ── Homebrew ────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Installing Brew packages"
brew bundle --file="$DOTFILES/Brewfile"

# ── oh-my-zsh ───────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ── Symlinks ─────────────────────────────────────────────────────────────────
symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  Backing up existing $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  $dst → $src"
}

echo "==> Symlinking configs"
symlink "$DOTFILES/nvim/config"       "$HOME/.config/nvim"
symlink "$DOTFILES/kitty/kitty.conf"  "$HOME/.config/kitty/kitty.conf"
symlink "$DOTFILES/kitty/current-theme.conf" "$HOME/.config/kitty/current-theme.conf"
symlink "$DOTFILES/zsh/.zshrc"        "$HOME/.zshrc"
symlink "$DOTFILES/zsh/.zprofile"     "$HOME/.zprofile"
symlink "$DOTFILES/zsh/.zshenv"       "$HOME/.zshenv"
symlink "$DOTFILES/git/.gitconfig"    "$HOME/.gitconfig"

echo ""
echo "Done! Open a new terminal or run: source ~/.zshrc"
