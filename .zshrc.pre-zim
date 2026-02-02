# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Prefer user-local bins (safe + de-duplicated).
typeset -U path PATH
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$HOME/bin" ]] && path=("$HOME/bin" $path)

# User configuration
# Use starship
eval "$(starship init zsh)"

# History: more useful defaults.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Keybindings: Emacs-style (Ctrl-A/Ctrl-E etc). Change to -v if you prefer vi.
bindkey -e
# You may need to manually set your language environment
# export LANG=zh_CN.UTF-8
export EDITOR=nvim

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="$EDITOR ~/.zshrc"
# Replace ls with eza
alias ls='eza --icons'

# Long format with headers and icons
alias ll='eza -l --header --icons'

# Long format including hidden files
alias la='eza -la --header --icons'

# Tree view shortcut
alias tree='eza --tree'

