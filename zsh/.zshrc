export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="avit"

zstyle ':omz:update' mode reminder

plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR="nvim"

# PATH
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.local/bin:$HOME/.cabal/bin:$HOME/.ghcup/bin:$PYENV_ROOT/bin:$PATH"
[ -d "$HOME/.emacs.d/bin" ] && export PATH="$PATH:$HOME/.emacs.d/bin"

# Aliases (DEV_DIR defaults to ~/dev; override it in ~/.zshrc.local)
alias zshconfig="nvim ~/.zshrc"
alias home="cd ~/"
alias dev='cd "$DEV_DIR"'
alias hs='cd "$DEV_DIR/haskell"'
alias rs='cd "$DEV_DIR/rust"'
alias py='cd "$DEV_DIR/python"'

# rbenv
command -v rbenv &>/dev/null && eval "$(rbenv init - zsh)"

# pyenv
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init -)"
  [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ] && eval "$(pyenv virtualenv-init -)"
fi

# direnv
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# Local/machine-specific secrets (not tracked in git)
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# Local/machine-specific overrides (not tracked in git)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

: ${DEV_DIR:=$HOME/dev}
