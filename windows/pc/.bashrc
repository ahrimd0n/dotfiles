# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
alias newtapeid='id=""; while [ -z "$id" ] || grep -qxF "$id" -ids.txt 2>/dev/null; do id="C-$(tr -dc "0123456789ABCDEFGHJKMNPQRSTVWXYZ" < /dev/urandom | head -c5)"; done; echo "$id" | tee -a ids.txt'

alias cls='clear'

export PATH="/d/ffmpeg/bin:$PATH"

# export PATH="/i/_Rips/Family/scripts:$PATH"

alias ffmpeg='ffmpeg -hide_banner 2>&1'
alias ffprobe='ffprobe -hide_banner 2>&1'


# tmux aliases
# Attaches tmux to the last session; creates a new session if none exists.
alias t='tmux attach || tmux new-session'

# Attaches tmux to a session (example: ta portal)
alias ta='tmux attach -t'

# Creates a new session
alias tn='tmux new-session -t'

# Lists all ongoing sessions
alias tl='tmux list-sessions'


# DISC ALIASES
# alias eject-all='for dev in /dev/sr0 /dev/sr1; do eject "$dev" & done; wait'

eject-all() {
  for dev in /dev/sr*; do
    eject "$dev" &
  done
  wait
}

umount-all() {
  shopt -s nullglob

  umount_try() {
    local target="$1"
    printf "Unmounting %-30s ... " "$target"
    if sudo umount "$target"; then
      echo "OK"
    else
      echo "FAIL"
    fi
  }

  for dev in /dev/sr* /media/"$USER"/*; do
    umount_try "$dev"
  done

  echo "Detaching loop devices..."
  sudo losetup -D

  echo "Syncing disks..."
  sync

  echo "Dropping caches..."
  echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null
}

export PATH=$PATH:/home/ubuntu/Desktop/bink-decoder

alias startlaptop='wakeonlan 78-24-AF-A5-2D-28'

alias makemkvcon='faketime "2025-07-01 12:00:00" makemkvcon "$@"'
alias makemkv='faketime "2025-07-01 12:00:00" makemkv'

py() {
    if [ $# -eq 0 ]; then
        python3  # Start interactive Python if no args
    else
        python3 "$@"  # Run with arguments
    fi
}
complete -f py # Enable filename bash completion

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space
HISTCONTROL=ignoreboth:erasedups

# Keep unlimited history
HISTSIZE=
HISTFILESIZE=

# Append history instead of overwriting
shopt -s histappend

# Real-time history sync across terminals
PROMPT_COMMAND='history -a; history -c; history -r'

# Add timestamps to history
HISTTIMEFORMAT="%F %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
export PATH="$HOME/.local/bin:$PATH"
