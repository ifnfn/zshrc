autoload -Uz compinit
compinit

#color{{{
autoload colors
colors

HIST_STAMPS="yyyy-mm-dd"

# load lib
for plugin in $(print -l $ZSH/lib/[a-z]*.zsh); do
  [ -f $plugin ] && . $plugin
done

# loading plugins
for plugin ($plugins); do
    plugin_file=$ZSH/plugins/$plugin/$plugin.plugin.zsh
    [ -f $plugin_file ] && source $plugin_file
done

# 文件批量重命令
autoload -U zmv


#自动补全功能 {{{
# setopt AUTO_LIST
#开启此选项，补全时会直接选中菜单项, 开启后按 TAB 就选中，不开两次 TAB 选中 
# setopt MENU_COMPLETE

#错误校正
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
 
# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}}


##行编辑高亮模式 {{{
# Ctrl+@ 设置标记，标记和光标点之间为 region
zle_highlight=(region:bg=magenta #选中区域
special:bold      #特殊字符
isearch:underline)#搜索时使用的关键字
#}}}
 
##空行(光标在行首)补全 "cd " {{{
user-complete(){
    case $BUFFER in
        "" )                       # 空行填入 "cd "
            BUFFER="cd "
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd --" )                  # "cd --" 替换为 "cd +"
            BUFFER="cd +"
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd +-" )                  # "cd +-" 替换为 "cd -"
            BUFFER="cd -"
            zle end-of-line
            zle expand-or-complete
            ;;
        * )
            zle expand-or-complete
            ;;
    esac
}

zle -N user-complete
bindkey "\t" user-complete
#}}}
 
zmodload zsh/mathfunc
autoload -U zsh-mime-setup
zsh-mime-setup
setopt EXTENDED_GLOB
 
setopt correctall
autoload compinstall
 
#漂亮又实用的命令高亮界面
setopt extended_glob
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')
