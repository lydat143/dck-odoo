#!/usr/bin/env zsh

echo " "
echo -e "\e[38;5;36m                     __                                         "
echo -e "\e[38;5;36m                    (__)                                        "
echo -e "\e[38;5;36m         __          __   _________          ______________     "
echo -e "\e[38;5;36m        /  \        |  | |   ____  )        |_____    _____|    "
echo -e "\e[38;5;36m       /    \       |  | |  |    ) )              |  |          "
echo -e "\e[38;5;36m      /  /\  \      |  | |  |____) )              |  |          "
echo -e "\e[38;5;36m     /  /  \  \     |  | |     ____)              |  |          "
echo -e "\e[38;5;36m    /  /____\  \    |  | |  |\  \      ______     |  |          "
echo -e "\e[38;5;36m   /   ______   \   |  | |  | \  \    |______|    |  |          "
echo -e "\e[38;5;36m  /  /        \  \  |  | |  |  \  \               |  |          "
echo -e "\e[38;5;36m /__/          \__\ |__| |__|   \__\              |__|          "
echo -e "\e[38;5;36m                                                                "
echo " "

# Install Oh-My-ZSH at first time
if [[ ! -d $HOME/.oh-my-zsh ]]; then
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="bira"
ZSH_THEME="gnzh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Automatically upgrade itself without prompting
DISABLE_UPDATE_PROMPT=true

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(command-not-found common-aliases docker docker-compose
         fancy-ctrl-z extract git git-extras git-remote-branch gitignore history
         history-substring-search pip python screen sudo supervisor tmux ubuntu
         virtualenv zsh_reload)

# User configuration

# virtual environment
if [[ -e "$VIRTUAL_ENV" ]]; then
    venv=$(basename $VIRTUAL_ENV)
    export PATH="$VIRTUAL_ENV/bin:$PATH"
fi

source $ZSH/oh-my-zsh.sh

# Color listing
eval $(dircolors ~/.dircolors)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

export EDITOR=vim
export DISPLAY=':0'
export REQUESTS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"
export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Your customize: aliases, functions .v.v.
[[ -s $HOME/.my_zshell ]] && source $HOME/.my_zshell

# Get PostgreSQL env
[[ -s $HOME/.pg_env ]] && source $HOME/.pg_env

### Keychain ###
# Let re-use ssh-agent between logins
eval $(keychain --eval -Q --quiet --attempts 5 id_ed25519 id_rsa)
source $HOME/.keychain/$(hostname)-sh
