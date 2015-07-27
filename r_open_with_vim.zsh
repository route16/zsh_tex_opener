# zsh tex opener
# Copyright (C) 2015 by route16 <route16@gmail.com>

zsh_tex_opener_enabled=1

r_open_with_vim_flag=0

function r_precmdhook_setflag() {
if [ $zsh_tex_opener_enabled -ne 1 ]; then
  return
fi
fromarg=${(z)2}
arg_num=${#fromarg[@]}
if [ ${arg_num} -eq 2 ]; then
  if [ $fromarg[1] = "open" ]; then
    if [ ${(l:4:)fromarg[2]} = ".tex" ]; then
      r_open_with_vim_flag=1
    elif [ ${(l:1:)fromarg[2]} = "." ] && [ -e ${fromarg[2]}tex ]; then
      r_open_with_vim_flag=2
    elif [ -e ${fromarg[2]}.tex ]; then
      r_open_with_vim_flag=3
    fi
  fi
  if [ `ps | grep vim | grep -e "${fromarg[2]}" | grep "\.tex" | wc -l` -ne 0 ]; then
    r_open_with_vim_flag=0
  fi
fi
if [ ${r_open_with_vim_flag} -eq 1 ]; then
  vim ${fromarg[2]} & 
elif [ ${r_open_with_vim_flag} -eq 2 ]; then
  open ${fromarg[2]}tex
  vim ${fromarg[2]}tex &
elif [ ${r_open_with_vim_flag} -eq 3 ]; then
  open ${fromarg[2]}.tex
  vim ${fromarg[2]}.tex &
fi
}

function r_postcmdhook_fg() {
if [ ${r_open_with_vim_flag} -ge 1 ]; then
  jobs_result=$(jobs)
  if [ ${jobs_result}_ != "_" ]; then
    fg 2> /dev/null
  fi
fi
unset jobs_result
r_open_with_vim_flag=0
}

add-zsh-hook preexec r_precmdhook_setflag
add-zsh-hook precmd r_postcmdhook_fg
