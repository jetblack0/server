# Interactive zsh: plugins, prompt, history, keys, aliases.
#
# shellcheck shell=bash
# shellcheck disable=SC2296  # ${(%):-%n} and ${(s.:.)X} are zsh expansion flags
# shellcheck disable=SC1090,SC1091  # sourced paths are runtime values
# shellcheck disable=SC2034  # SAVEHIST and KEYTIMEOUT are read by zsh itself
# shellcheck disable=SC2139  # aliases below expand at login on purpose
# shellcheck disable=SC2154,SC1105,SC2211,SC2288  # (( $+commands[x] )) guards

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Keymap
# ---------------------------------------------
bindkey -v


# PATH
# ---------------------------------------------
typeset -U PATH path fpath

# Prepended, so these shadow the system copies. /usr/local/bin is where the
# upstream releases land, and a login shell is not always the thing that
# started this one -- sudo's secure_path in particular drops it.
export PATH="$HOME/.local/bin:/usr/local/bin:$CARGO_HOME/bin:$PATH"

# Appended: only reached when nothing earlier provides the command.
export PATH="$PATH:$NPM_PACKAGES/bin:${KREW_ROOT:-$HOME/.krew}/bin"

# MANPATH is deliberately not set: man derives <prefix>/share/man and
# <prefix>/man from every <prefix>/bin on PATH, so the entries above are
# already covered. Setting it would only add entries twice.


# Plugins
# ---------------------------------------------
# zinit bootstrap.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# Local plugins. simple-completion.zsh runs its own compinit.
source "$ZDOTDIR/plugins/simple-completion.zsh"

# Replay any compdefs registered before compinit ran.
zinit cdreplay -q


# Prompt
# ---------------------------------------------
[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"


# History
# ---------------------------------------------
HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"
HISTSIZE=9223372036854775807
SAVEHIST=$HISTSIZE

# Every pane sees every other pane's history as it is typed.
setopt sharehistory
# A leading space keeps a command out of the file entirely.
setopt hist_ignore_space
# Drop duplicates on write, and skip them again when searching.
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups


# Completion
# ---------------------------------------------
(( $+commands[dircolors] )) && eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# Keybindings
# ---------------------------------------------
# No ESC delay in vi mode.
KEYTIMEOUT=1

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Launchers. Each one clears the line first (^u) so it also works mid-command.
bindkey -s '^f' '^uyy\n'
bindkey -s '^v' '^unvim .\n'
bindkey -s '^o' '^uzicd\n'
bindkey -s '^e' '^ufzfed\n'


# Aliases
# ---------------------------------------------
alias vim="nvim"
alias ip="ip -c=always"
# The trailing space makes zsh expand the *next* word as an alias too, so
# things like `sudo ll` keep working.
alias sudo="sudo "

# Tools that write to $HOME unless told otherwise.
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"

# Modern alternatives.
alias ls="eza"
alias ll="ls -lHg"
alias lla="ll -a"
alias la="ls -a"
alias grep="rg"
alias cat="bat"
alias diff="delta"

# Typos.
alias s="ls"
alias sl="ls"
alias l="ls"
alias nivm="nvim"
alias suod="sudo"
alias sduo="sudo"

# systemd.
alias ctl="systemctl"
alias clt="systemctl"
alias jclt="journalctl"
alias jctl="journalctl"
alias rctl="resolvectl"
alias rclt="resolvectl"
alias lctl="loginctl"
alias lclt="loginctl"
alias nctl="networkctl"
alias nclt="networkctl"
alias tctl="timedatectl"
alias tclt="timedatectl"
alias hctl="hostnamectl"
alias hclt="hostnamectl"
alias cgtop="systemd-cgtop"
alias cgls="systemd-cgls"


# Integrations
# ---------------------------------------------
(( $+commands[fzf] )) && eval "$(fzf --zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init --cmd cd zsh)"


# Functions
# ---------------------------------------------
tree() {
	local depth=2
	if [[ $1 =~ ^[0-9]+$ ]]; then
		depth=$1
		shift
	fi
	eza -T -L "$depth" "$@"
}

# Open yazi, and stay in whatever directory it was left in.
yy() {
	local tmp cwd
	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	cwd="$(command cat -- "$tmp")"
	rm -f -- "$tmp"
	if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd" || return
	fi
}

# Jump to a directory picked out of the zoxide database.
zicd() {
	local dir
	dir=$(zoxide query --interactive)

	[ -z "$dir" ] && echo "cancelled" && return 0
	[ ! -d "$dir" ] && echo "not a dir" && return 1

	__zoxide_z "$dir" || return 1
}

# Edit one of the config files.
fzfed() {
	local files file
	files=(
		"$XDG_DATA_HOME/zsh/zsh_history"
		"$HOME/.zshenv"
		"$ZDOTDIR/.zshenv"
		"$ZDOTDIR/.zshrc"
		"$XDG_CONFIG_HOME/tmux/tmux.conf"
		"$XDG_CONFIG_HOME/bat/config"

		"$HOME/.ssh/config"
		"$HOME/.gitconfig"
	)

	file=$(printf "%s\n" "${files[@]}" | fzf \
		--preview 'bat --style=numbers,changes --color=always {}' \
		--preview-window=right \
		--bind=alt-k:up,alt-j:down \
		--height=20 \
		--layout=reverse \
		--cycle \
		--border=sharp
	)

	[ -z "$file" ] && echo "cancelled" && return 0
	[ ! -e "$file" ] && echo "not a file" && return 1

	nvim "$file"
}
