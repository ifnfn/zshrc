# check if fasd is installed
if (( ! ${+commands[fasd]} )); then
  return
fi

eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"
alias v='f -e "$EDITOR"'
alias o='a -e xdg-open'
alias j='zz'

# eval "$(fasd --init auto)"
# alias a='fasd -a'        # any
# alias s='fasd -si'       # show / search / select
# alias d='fasd -d'        # directory
# alias f='fasd -f'        # file
# alias sd='fasd -sid'     # interactive directory selection
# alias sf='fasd -sif'     # interactive file selection
# alias z='fasd_cd -d'     # cd, same functionality as j in autojump
# alias zz='fasd_cd -d -i' # cd with interactive selection
# alias v='f -e vim'       # quick opening files with vim
