#
# ~/.bashrc
#


# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

PS1='[\u@\h \W]\$ '

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


EDITOR="micro"


# Load up solarized colorscheme for dircolors (ls ouput)
#eval `dircolors ~/dotfiles/source/dircolors-solarized/dircolors.ansi-dark`

# Add dotfile binaries to path
export PATH=$(ruby -e 'print Gem.user_dir')/bin:$HOME/stow/bin:$HOME/.npm-global/bin:$HOME/.local/bin:~/dev/activator:~/.poetry/bin:$PATH
export PATH="$PATH:$HOME/go/bin"
export GOBIN=$HOME/go/bin

export TERM=xterm-256color

systemctl --user import-environment

# Do not allow poetry to change the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Set XDG Base Directories
# https://wiki.archlinux.org/index.php/XDG_Base_Directory
XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache
XDG_DATA_HOME=$HOME/.local/share


# Add Radicle to path
export PATH="$HOME/.radicle/bin:$PATH"

# Init pyenv
eval "$(pyenv init -)"

# source /home/stratos/.config/broot/launcher/bash/br
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

eval "$(starship init bash)"
