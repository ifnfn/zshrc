_fish_collapsed_pwd() {
    local IFS="/"
    local pwd="$1"
    local home="$HOME"
    local size=${#home}
    [[ $# == 0 ]] && pwd="$PWD"
    [[ -z "$pwd" ]] && return
    if [[ "$pwd" == "/" ]]; then
        echo "/"
        return
    elif [[ "$pwd" == "$home" ]]; then
        echo "~"
        return
    fi
    [[ "$pwd" == "$home/"* ]] && pwd="~${pwd:$size}"
    local elements=("${(s:/:)pwd}")
    local length=${#elements}
    if [[ $(($length-3 )) > 1 ]]; then
        local idx=$(($length-3))
        elements=${elements[*]:${idx}}
        echo "~/.../${elements[*]}"
    else
        echo "${elements[*]}"
    fi
}

if [ -n "$BASH_VERSION" ]; then
    if [ "$UID" -eq 0 ]; then
        export PS1='\h \[\e[31m\]$(_fish_collapsed_pwd)\[\e[0m\]# '
    else
        export PS1='\h \[\e[32m\]$(_fish_collapsed_pwd)\[\e[0m\]> '
    fi
else
    setopt PROMPT_SUBST
    if [ $UID -eq 0 ]; then
	export PROMPT='$CYAN%n@$YELLOW%m:$FG[039]$(_fish_collapsed_pwd)%f # '
    else
	# PROMPT=$(echo "$CYAN%n@$YELLOW%M:$GREEN%/$_YELLOW>$FINISH ")
	export PROMPT='$CYAN%n@$YELLOW%m:$FG[039]$GREEN$(_fish_collapsed_pwd)%f > '
    fi
fi
