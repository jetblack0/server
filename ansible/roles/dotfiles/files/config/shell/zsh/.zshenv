# Environment for every zsh, interactive or not.
#
# ZDOTDIR, the XDG directories and LANG are already set: ~/.zshenv does that,
# then sources this. Nothing here may assume a terminal or print anything.
#
# PATH is built in .zshrc rather than here, so that a login shell running
# /etc/profile afterwards cannot reorder it.
#
# shellcheck shell=bash
# shellcheck disable=SC2034  # zsh reads skip_global_compinit itself
# shellcheck disable=SC2296  # ${(%):-%m} is a zsh expansion flag, not bash


# Shell
# ---------------------------------------------
# Skip the compinit that /etc/zshrc runs; plugins/simple-completion.zsh runs
# its own, later, against $ZSH_COMPDUMP.
skip_global_compinit=1

export ZSH_COMPDUMP="$XDG_CACHE_HOME"/zsh/.zcompdump-${(%):-%m}-${ZSH_VERSION}
export INPUTRC="$XDG_CONFIG_HOME"/shell/inputrc


# Default programs
# ---------------------------------------------
export EDITOR="nvim"


# XDG paths: terminal
# ---------------------------------------------
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
# Where `kitten ssh` and friends drop a terminfo entry the box does not carry.
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo


# XDG paths: languages and runtimes
# ---------------------------------------------
# rust
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# go
export GOPATH="$XDG_DATA_HOME"/go

# node and npm
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_PACKAGES="$XDG_DATA_HOME"/npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc


# XDG paths: database clients
# ---------------------------------------------
export PSQL_HISTORY="$XDG_DATA_HOME"/psql_history
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export REDISCLI_HISTFILE="$XDG_DATA_HOME"/redis/rediscli_history


# XDG paths: ops tooling
# ---------------------------------------------
export ANSIBLE_HOME="$XDG_DATA_HOME"/ansible
export ANSIBLE_COLOR_DOC_CONSTANT="bright green"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

# kubernetes
export KREW_ROOT="$XDG_DATA_HOME"/krew

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export AWS_PAGER=""


# fzf
# ---------------------------------------------
fzf_base_options='--bind=alt-k:up,alt-j:down --height=10 --layout=reverse --cycle'
# Gruvbox
export FZF_DEFAULT_OPTS="$fzf_base_options --color=fg:#ebdbb2,hl:#b16286 --color=fg+:#689d6a,bg+:#32302f,hl+:#d3869b --color=info:#d65d0e,prompt:#458588,pointer:#fe8019 --color=marker:#8ec07c,spinner:#cc241d,header:#fabd2f"
unset fzf_base_options

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND='rg --files --hidden .'
export FZF_ALT_C_COMMAND='rg --hidden --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq'


# Pagers
# ---------------------------------------------
# -R lets colour through, -i makes search case insensitive.
export LESS=-Ri
export DELTA_PAGER="less"

# bat
# export BAT_STYLE="header,numbers,plain"
# export BAT_PAGER=""

# Colours for man pages.
export LESS_TERMCAP_mb=$'\e[1;31m'     # start blink
export LESS_TERMCAP_md=$'\e[1;32m'     # start bold -- section headings
export LESS_TERMCAP_so=$'\e[01;44;37m' # start standout -- the status line
export LESS_TERMCAP_us=$'\e[01;37m'    # start underline -- arguments
export LESS_TERMCAP_me=$'\e[0m'        # stop bold and blink
export LESS_TERMCAP_se=$'\e[0m'        # stop standout
export LESS_TERMCAP_ue=$'\e[0m'        # stop underline
# Without this, groff emits SGR sequences the escapes above cannot override.
export GROFF_NO_SGR=1
