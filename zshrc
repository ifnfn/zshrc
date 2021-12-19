eval "$([ -f /opt/homebrew/bin/brew ] && /opt/homebrew/bin/brew shellenv)"
export LANG=en_US.UTF-8
export REPO_URL=https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/

export ZSH=$HOME/.zsh.git

# 命令补全时区别大小写
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
HIST_STAMPS="yyyy-mm-dd"

source $ZSH/init.zsh

#[Esc][h] man 当前命令时，显示简短说明
alias run-help >&/dev/null && unalias run-help
autoload run-help
bindkey '^h' run-help


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

# 以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}}
 
 
# {{{自定义补全
#补全 ping
zstyle ':completion:*:ping:*' hosts 192.168.1.{1,50,51,100,101} www.google.com
 
# 补全 ssh scp sftp 等
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
#}}}
