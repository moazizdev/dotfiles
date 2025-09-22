if status is-interactive
	# Commands to run in interactive sessions can go here
	
	if string match -qir '.*\.utf-?8' -- $LANG $LC_CTYPE
	    set -l animal_marine 🐳 🐋 🐬 🦭  🐟 🐠 🐡 🦈 🐙 🐚
	    set -l animal_reptile 🐸 🐢
	    set -l food_marine 🦀 🦞 🦐 🦑

	    set fishes $animal_marine $animal_reptile $food_marine

	    function fishes_greeting
	      echo (random choice $fishes; random choice $fishes; random choice $fishes)
	    end

	    set fish_greeting "Welcome! Let's fish! "(fishes_greeting)
	end
	
	#set -g fish_greeting "Welcome! Let's fish! 🐟 🐠"
	alias dotfiles 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
end

# custom XDG varibales to clean Home directory
set XDG_DATA_HOME 	"$HOME/.local/share"
set XDG_CONFIG_HOME 	"$HOME/.config"
set XDG_STATE_HOME  	"$HOME/.local/state"
set XDG_CACHE_HOME 	"$HOME/.cache"

set HISTFILE 		"$XDG_STATE_HOME"/bash/history
set CUDA_CACHE_PATH 	"$XDG_CACHE_HOME"/nv
set __GL_SHADER_DISK_CACHE_PATH 	"$XDG_CACHE_HOME"/nv
set GNUPGHOME		"$XDG_DATA_HOME"/gnupg
set LESSHISTFILE	"$XDG_CACHE_HOME"/less/history
set NPM_CONFIG_USERCONFIG		"$XDG_CONFIG_HOME"/npm/npmrc
set PGPASSFILE		"$XDG_CONFIG_HOME"/pg/pgpass

# custom alias
alias doom="$XDG_CONFIG_HOME/emacs/bin/doom"
