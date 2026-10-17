#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing dotfiles from $DOTFILES"

# ── Helpers (Fedora) ────────────────────────────────────────────────────────
# Latest GitHub release binary → ~/.local/bin, verified against the release's checksums.
install_release() {
  local repo="$1" bin="$2" arch api asset sums tmp
  arch="$(uname -m)"; [ "$arch" = "aarch64" ] && arch="arm64"
  api="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest")"
  asset="$(jq -r --arg a "$arch" '.assets[].browser_download_url | select(test("linux_" + $a + "\\.tar\\.gz$"; "i"))' <<<"$api" | head -1)"
  sums="$(jq -r '.assets[].browser_download_url | select(test("checksums\\.txt$"))' <<<"$api" | head -1)"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/${asset##*/}" "$asset"
  curl -fsSL -o "$tmp/checksums.txt" "$sums"
  (cd "$tmp" && awk -v f="${asset##*/}" '$2 == f' checksums.txt | sha256sum -c --quiet --strict)
  tar -xzf "$tmp/${asset##*/}" -C "$tmp" "$bin"
  install -Dm755 "$tmp/$bin" "$HOME/.local/bin/$bin"
  rm -rf "$tmp"
  echo "  $bin $(basename "$(dirname "$asset")")"
}

# Nerd Font → ~/.local/share/fonts, verified against the release's SHA-256.txt.
install_nerd_font() {
  local name="$1" dir="$HOME/.local/share/fonts/${1}NerdFont" tmp
  local base="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
  [ -d "$dir" ] && return
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/$name.tar.xz" "$base/$name.tar.xz"
  curl -fsSL -o "$tmp/SHA-256.txt" "$base/SHA-256.txt"
  (cd "$tmp" && awk -v f="$name.tar.xz" '$2 == f' SHA-256.txt | sha256sum -c --quiet --strict)
  mkdir -p "$dir"
  tar -xJf "$tmp/$name.tar.xz" -C "$dir"
  fc-cache -f "$dir" >/dev/null
  rm -rf "$tmp"
  echo "  $name Nerd Font"
}

# ── Packages ────────────────────────────────────────────────────────────────
case "$(uname -s)" in
  Darwin)
    if ! command -v brew &>/dev/null; then
      echo "==> Installing Homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "==> Installing Brew packages"
    brew bundle --file="$DOTFILES/Brewfile"
    ;;
  Linux)
    if [ ! -f /etc/fedora-release ]; then
      echo "Unsupported Linux distribution (only Fedora is supported)" >&2
      exit 1
    fi

    echo "==> Installing dnf packages"
    sudo dnf install -y $(grep -vE '^\s*(#|$)' "$DOTFILES/packages-fedora.txt")

    echo "==> Installing Lazy* TUI tools"
    install_release jesseduffield/lazygit lazygit
    install_release jesseduffield/lazydocker lazydocker
    install_release jorgerojas26/lazysql lazysql

    echo "==> Installing fonts"
    install_nerd_font FiraCode
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

# ── oh-my-zsh ───────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ── Symlinks ─────────────────────────────────────────────────────────────────
symlink() {
  local src="$1" dst="$2" bak
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    echo "  Backing up existing $dst → $bak"
    mv "$dst" "$bak"
  fi
  ln -sfn "$src" "$dst"
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
