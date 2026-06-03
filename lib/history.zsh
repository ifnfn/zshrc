## History wrapper
function omz_history {
  # parse arguments and remove from $@
  local clear list stamp REPLY
  zparseopts -E -D c=clear l=list f=stamp E=stamp i=stamp t:=stamp

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file

    # confirm action before deleting history
    print -nu2 "This action will irreversibly delete your command history. Are you sure? [y/N] "
    builtin read -E
    [[ "$REPLY" = [yY] ]] || return 0

    print -nu2 >| "$HISTFILE"
    fc -p "$HISTFILE"

    print -u2 History file deleted.
  elif [[ $# -eq 0 ]]; then
    # if no arguments provided, show full history starting from 1
    builtin fc "${stamp[@]}" -l 1
  else
    # otherwise, run `fc -l` with a custom format
    builtin fc "${stamp[@]}" -l "$@"
  fi
}

# Timestamp format
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt extended_history       # 为历史纪录中的命令添加时间戳
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # 如果连续输入的命令相同，历史纪录中只保留一个
setopt hist_ignore_space      # 在命令前添加空格，不将此命令添加到纪录文件中
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # 以附加的方式写入历史纪录
setopt share_history          # share command history data
setopt hist_reduce_blanks     # Remove blank lines from history
setopt hist_ignore_all_dups   # Remove all duplicates from history

#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS
