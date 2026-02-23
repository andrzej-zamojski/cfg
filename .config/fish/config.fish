set -gx CDPATH $CDPATH .
set -gx FZF_DEFAULT_COMMAND 'fdfind --type f --hidden --exclude .git -I'

set -g fish_prompt_pwd_dir_length 0

# 2. Force-disable ALL git status features
set -g __fish_git_prompt_show_informative_status 0
set -g __fish_git_prompt_showdirtystate 0
set -g __fish_git_prompt_showuntrackedfiles 0
set -g __fish_git_prompt_showupstream none
set -g __fish_git_prompt_showstashstate 0
set -g __fish_git_prompt_showcolorhints 1

# 3. Clean up the symbols just in case
set -g __fish_git_prompt_char_stateseparator ''
set -g __fish_git_prompt_char_dirtystate ''
set -g __fish_git_prompt_char_untrackedfiles ''
set -g __fish_git_prompt_char_stagedstate ''

function fish_prompt
	set -l cyan (set_color cyan)
	set -l blue (set_color blue)
	set -l green (set_color green)
	set -l normal (set_color normal)

	# 1. Output the Full Path
	echo -n -s $green (prompt_pwd)

	# 2. Manual Git Branch (Bypasses all built-in Fish status logic)
	set -l branch (git branch --show-current 2>/dev/null)
	if test -n "$branch"
		echo -n -s $cyan " ($branch)"
	end

	# 3. Prompt symbol
	echo -n -s $normal " \$ "
end
