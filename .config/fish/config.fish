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
