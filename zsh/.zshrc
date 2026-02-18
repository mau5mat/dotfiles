export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="avit"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"

# Aliases
alias zshconfig="nvim ~/.zshrc"
alias home="cd ~/"
alias dev="cd ~/Development/"

# rbenv
eval "$(rbenv init - zsh)"

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Local/machine-specific secrets (not tracked in git)
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"
