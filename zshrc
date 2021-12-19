eval "$([ -f /opt/homebrew/bin/brew ] && /opt/homebrew/bin/brew shellenv)"
export LANG=en_US.UTF-8
export REPO_URL=https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/

export ZSH=$HOME/.zsh.git
export JIRA_URL=https://jira.nioint.com

# 命令补全时区别大小写
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# 历史时间格式
HIST_STAMPS="yyyy-mm-dd"

DISABLE_AUTO_UPDATE=true

# 以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

plugins=(
    sudo fasd git iterm2 repo rsync man gnu-utils 
    colored-man-pages extract encode64 history
    jira macos web-search
    common-aliases
    prompt_fish
    autosuggestions
)

source $ZSH/oh-my-zsh.sh

# 自定义别名
alias vv=vsplit_tab  # 竖分屏
alias hh=split_tab   # 模分屏
alias fy='trans :zh'
alias ncp='foo(){scp "$1"  ~/works/nvos/os/drivers/lxdrv/libs/liblx/include/$2}; foo '
[ -f /opt/homebrew/bin/cpio ] &&  alias cpio=/opt/homebrew/bin/cpio

#编辑器
export EDITOR=vim

#杂项 {{{
#允许在交互模式中使用注释  例如：
#cmd #这是注释
setopt INTERACTIVE_COMMENTS
 
#禁用 core dumps
limit coredumpsize 0

# Emacs风格 键绑定
# bindkey -e
# bindkey -v

#}}}
 
 
# {{{自定义补全
#补全 ping
zstyle ':completion:*:ping:*' hosts 192.168.1.{1,50,51,100,101} www.google.com
 
# 补全 ssh scp sftp 等
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

#错误校正
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
 
# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
# }}}

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

# 文件批量重命令
autoload -U zmv

#[Esc][h] man 当前命令时，显示简短说明
alias run-help >&/dev/null && unalias run-help
autoload run-help
bindkey '^h' run-help

#漂亮又实用的命令高亮界面
setopt EXTENDED_GLOB
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')
