# zsh tex opener
# Copyright (C) 2015 by route16 <route16@gmail.com>

r_open_with_vim_flag=0

function r_precmdhook_setflag() {
fromarg=${(z)2}
arg_num=${#fromarg[@]}
if [ ${arg_num} -eq 2 ]; then
  if [ $fromarg[1] = "open" ]; then
    if [ `basename $fromarg[2] .tex` != `basename $fromarg[2]` ]; then
      r_open_with_vim_flag=1
    fi
  fi
fi
if [ ${r_open_with_vim_flag} -eq 1 ]; then
  vim $fromarg[2] & 
fi
}

function r_postcmdhook_fg() {
jobs_result=$(jobs)
if [ ${r_open_with_vim_flag} -eq 1 ]; then
  if [ ${jobs_result}_ != "_" ]; then
    fg 2> /dev/null
  fi
fi
unset jobs_result
r_open_with_vim_flag=0
}

add-zsh-hook preexec r_precmdhook_setflag
add-zsh-hook precmd r_postcmdhook_fg
