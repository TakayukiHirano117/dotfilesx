if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_user_key_bindings
	for mode in default insert visual
		fish_default_key_bindings -M $mode
	end
	fish_vi_key_bindings --no-erase
	if test "$__fish_active_key_bindings" = fish_vi_key_bindings
		bind -M insert -m default jk force-repaint
end


end

set -Ux PATH $PATH $HOME/go/bin
set -gx PATH $HOME/go/bin $PATH
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH $HOME/.bun/bin $PATH
alias sail='sh (test -f sail; and echo sail; or echo vendor/bin/sail)'

alias pest='/usr/local/opt/php@8.2/bin/php ./vendor/bin/pest'
function vi
nvim $argv
end

function vim
nvim $argv
end

function nvim
command nvim $argv
end

set -Ux PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and source (rbenv init -|psub)
status --is-interactive; and rbenv init - fish | source
