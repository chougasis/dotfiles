# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/chougasis/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

###Personal Config###
#Start Up

#Looks
alias ls='ls --color=auto'
alias grep='grep --color=auto'
export PS1='%n@%m:%~/$ '


#Defaults
export EDITOR=nvim
export VISUAL=nvim

#Yazi Config
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


