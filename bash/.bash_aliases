#
# ~/.bash_aliases
#

# some more ls aliases
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


#tmux helpers
alias tmuxl='tmux list-sessions'
alias tmuxa='tmux attach-session -t $1'
alias tmuxk='tmux kill-session -t $1'

alias tmux-pplaavi="ssh pplaavi01 -t '/usr/bin/tmux -S /home/plaaviops/tmux/stratos.sock attach'"
#alias tmux-pplaavi="ssh pplaavi01 -t 'if tmux -S /home/plaaviops/tmux/stratos.sock has -t AO-PPS; then reattach-to-user-namespace tmux -S /home/plaaviops/tmux/stratos.sock attach; else reattach-to-user-namespace tmux -S /home/plaaviops/tmux/stratos.sock new -s AO-PPS; fi'"

# kill process holding port open
function killport() {
  sudo kill `lsof -t -i \:$1`;
};

alias kport=killport

alias e=emacsclient $1

alias m=micro
alias gtt='docker run --rm -it -v ~:/root kriskbx/gitlab-time-tracker'

