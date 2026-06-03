# Homebrew 初始化（仅 macOS）
[[ "$(uname)" = Darwin ]] && eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)"
export LANG=en_US.UTF-8
export REPO_URL=https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/

if [[ -d /usr/share/zsh/config ]]; then
    export ZSH=/usr/share/zsh/config
else
    export ZSH=$HOME/.zsh.git
fi

# 补全大小写不敏感（_ 和 - 可互换）
# CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"

# 历史时间格式
HIST_STAMPS="yyyy-mm-dd"

DISABLE_AUTO_UPDATE=true

# 以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

plugins=(
    common-aliases sudo prompt_fish gnu-utils history
    autosuggestions
    git git-flow repo rsync man
    colored-man-pages extract encode64
    jira web-search
    fasd ag fzf ripgrep vscode
)
# macOS 专有插件条件加载
[[ "$(uname)" = Darwin ]] && plugins+=(iterm2 macos)

# autosuggestions 补全部分的颜色（淡灰色）
# 可选值: fg=8(深灰/默认)  fg=240(暗灰)  fg=244(中灰)  fg=248(浅灰)
#        fg=6(暗青)  fg=4(暗蓝)  fg=5(暗紫)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

source $ZSH/oh-my-zsh.sh

# 自定义别名
alias vv=vsplit_tab  # 竖分屏
alias hh=split_tab   # 模分屏

# alias kdiff=kitty +kitten diff
# 截短主机名：取第一个 '-' 之前的部分（如 ea134-v-sw-remote-dev02 → ea134）
_short_host() { local h=$(hostname -s); echo ${h%%-*} }
export PROMPT='$CYAN%n@$YELLOW$(_short_host):$FG[039]$GREEN$(_fish_collapsed_pwd)%f > '

# {{{ 杂项
# 允许在交互模式中使用注释  例如：
# cmd #这是注释
setopt INTERACTIVE_COMMENTS

#禁用 core dumps
limit coredumpsize 0

# Emacs风格 键绑定
# bindkey -e
bindkey -v

# vi 模式下恢复 Ctrl-r 增量历史搜索
bindkey '^r' history-incremental-search-backward

# vi 模式下恢复 bash/emacs 习惯快捷键
# 光标移动
bindkey '^a' beginning-of-line      # Ctrl-a 行首（增量搜索中可退出搜索）
bindkey '^e' end-of-line            # Ctrl-e 行尾（增量搜索中可退出搜索）
bindkey '^f' forward-char           # Ctrl-f 前进一字符
bindkey '^b' backward-char          # Ctrl-b 后退一字符
bindkey '^[f' forward-word          # Alt-f 前进一词
bindkey '^[b' backward-word         # Alt-b 后退一词

# 删除/剪切
bindkey '^k' kill-line              # Ctrl-k 删到行尾
bindkey '^u' kill-whole-line        # Ctrl-u 删到行首
bindkey '^w' backward-kill-word     # Ctrl-w 删前一词（bash 风格，用空白分词）
bindkey '^d' delete-char-or-list    # Ctrl-d 删除当前字符/列补全
bindkey '^[d' kill-word             # Alt-d 删后一词

# 撤销/粘贴
bindkey '^_' undo                   # Ctrl-/ 撤销
bindkey '^y' yank                   # Ctrl-y 粘贴

# 历史导航
bindkey '^p' up-line-or-history     # Ctrl-p 上一条历史
bindkey '^n' down-line-or-history   # Ctrl-n 下一条历史
bindkey '^[.' insert-last-word      # Alt-. 上一条命令最后一个参数

# 词操作
bindkey '^t' transpose-chars        # Ctrl-t 交换两个字符
bindkey '^[t' transpose-words       # Alt-t 交换两个词
bindkey '^[c' capitalize-word       # Alt-c 首字母大写
bindkey '^[u' up-case-word          # Alt-u 全大写
bindkey '^[l' down-case-word        # Alt-l 全小写

#}}}


# {{{ 自定义补全
#补全 ping
zstyle ':completion:*:ping:*' hosts 192.168.1.{1,50,51,100,101} www.google.com

#错误校正
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
# }}}

## {{{ 空行(光标在行首)补全 "cd "
user-complete(){
    # 如果有 autosuggestion，Tab 接受建议
    if [[ -n "$POSTDISPLAY" ]]; then
        zle autosuggest-accept
        return
    fi
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
# .sh 文件用编辑器打开而非直接执行
zstyle ':mime:.sh:' handler '${EDITOR:-vi} %s'

# 文件批量重命名
autoload -U zmv

# 扩展通配符
setopt EXTENDED_GLOB

# PATH 追加（防重复）
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH=$HOME/.local/bin:$PATH || true
