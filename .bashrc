# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# vars:
EC2_DEV_USER="admin"
EC2_BASE_USER="ubuntu"
EC2_DEV_INSTANCE="<instance-id>"

# helpful regex cmds for working with linux/k8s logs
alias dd="sed -n '/DF/,/^$/{/./p}' general_info >> resources.log"
alias mm="sed -n '/VMSTAT/,/^$/{/./p}' general_info >> resources.log; sed -n '/FREE/,/^$/{/./p}' general_info >> resources.log"
alias dm="sed -n '/DMESG/,/^$/{/./p}' general_info > dmesg.log"
alias mt="sed -n '/MOUNT/,/^$/{/./p}' general_info >> resources.log"
alias tp="sed -n '/PID USER/,/^$/{/./p}' general_info > top.log && head -n 1 top.log >> resources.log && grep s1 top.log >> resources.log"
alias cc='echo endpoint has $(grep proc proc/cpuinfo |wc -l) cores |tee -a resources.log'

alias h='htop'
alias k='kubectl'
alias ip='curl ifconfig.io/all'
alias cls='clear'
alias lp='cp ~/Linux_Agent_LogParser.sh .; ./Linux_Agent_LogParser.sh'
alias grep='grep -i'
alias ipa='curl ifconfig.io/all.json |jq'
alias up='sudo apt-get update -y && sudo apt-get upgrade -y'
alias py='python3'
alias ports='sudo netstat -tulanp'
alias vb='vim ~/.bashrc'
alias sb='source ~/.bashrc'

alias db='ssh $EC2_DEV_USER@$(aws ec2 describe-instances --instance-ids $EC2_DEV_INSTANCE --query "Reservations[].Instances[].PublicIpAddress" --output text)'
alias get-instances="aws ec2 describe-instances --query \"Reservations[].Instances[].[InstanceId, Tags[?Key=='Name'].Value | [0], PublicIpAddress, State.Name]\" --output table"
alias get-dev-ip='aws ec2 describe-instances --instance-ids $EC2_DEV_INSTANCE --query "Reservations[].Instances[].PublicIpAddress" --output text'
alias start-dev='aws ec2 start-instances --instance-ids $EC2_DEV_INSTANCE'
alias stop-dev='aws ec2 stop-instances --instance-ids $EC2_DEV_INSTANCE'
# If not running interactively, don't do anything

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
#PS1='[\W]\n\u:\\$ '
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="\n\[$(tput setaf 216)\][\W]\[$(tput setaf 229)\]\$(parse_git_branch)\n\\u@\H\[$(tput sgr0)\]$ "
# If this is an xterm set the title to user@host:dir
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
alias ll='ls -alh'
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
