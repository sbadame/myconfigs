if [[ -f ~/.my_aliases ]]; then
    source ~/.my_aliases;
fi

#Some bash crap...
complete -cf sudo
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s nocaseglob

#vim stuff
export EDITOR=vim
export VISUAL=vim
set -o vi

#man (manual) stuff
export LESS_TERMCAP_mb=$'\e[01;34m'
export LESS_TERMCAP_md=$'\e[01;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[38;05;111m'

#Random program improvements
export GREP_COLOR="1;33"
alias grep='LC_ALL="C" grep --color=auto'
alias c="clear"
alias untar='tar -xzvf'
alias l="ls -lh --group-directories-first"
alias myip="lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print \$4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'"
alias vi='vim -X'
alias open='gnome-open'
alias top='htop'
alias pdfmerge='gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile='
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."


################################################################################
#           OK fun stuff... MY PROMPT!!!
################################################################################

#Try to git-ify it
function get_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"
}

function get_git_info {
  if [ -d .git ] || git rev-parse > /dev/null 2>&1 ; then
      if [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]]; then
        echo -en '\e[37;41m'"($(get_git_branch)*)"
      else
        echo -en '\e[37;44m'"($(get_git_branch))"
      fi
  fi
}

function shrink {
    currentWD=${PWD}
}

function unshrink {
    unset currentWD
}

function getShrunkenPWD {
    if [[ -n ${currentWD} ]]; then
        if [ $(echo $PWD | grep ${currentWD} - > /dev/null)$? -eq 1 ]; then
            unshrink
            echo ${PWD} | sed "s:${HOME}:~:" -
        else

            echo ^$(basename $currentWD)$(echo ${PWD} | sed "s:^${currentWD}\(.*\):\1:")
        fi
    else
        echo ${PWD} | sed "s:${HOME}:~:" -
    fi
}

#Here is my fancy prompt
PS1="\n\[\e[47m\]\[\e[1;30m\]\$(getShrunkenPWD) \[\e[0m\]\[\e[1;37m\]\[\e[1;37m\]\$(get_git_info)\[\e[00m\] \n> "


#################################################################################
#            Same handy functions....
#################################################################################

function jarfind {
    pattern=$1
    shift
    for jar in "$@"; do
        output=`unzip -l "$@" | grep $pattern`
        if [[ -n $output ]]; then
            echo -e "Found in: $jar\n$output"
        fi
    done
}

function mkcd {
 mkdir -p "$@" && builtin cd "$@"
}

function grepkill {
    ps aux | grep $1 | head -n 1 | awk '{print $2}' | xargs kill -9
}


function tex2pdf {
    if [ -f "$1.tex" ]; then
        pdflatex $1
        bibtex $1
        pdflatex $1
        pdflatex $1
        rm *.aux *.log *.dvi *.blg *.bbl
    else
        echo "'$1' does not exist"
    fi
}

function mktex {
   if [ -f "$1.tex" ]; then
      echo "'$1' already exists, cannot make a text file here"
   else
      cat ~/.aliashelp/template.tex | sed s/Title/$1/g > "$1.tex"
   fi
}

function showme {
    for pid in `xdotool search --class $1`;do
        xdotool windowactivate $pid;
    done
}

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1        ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       rar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xf $1        ;;
            *.tbz2)      tar xjf $1      ;;
            *.tgz)       tar xzf $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

compress () {
   FILE=$1
   shift
   case $FILE in
      *.tar.bz2) tar cjf $FILE $*  ;;
      *.tar.gz)  tar czf $FILE $*  ;;
      *.tgz)     tar czf $FILE $*  ;;
      *.zip)     zip $FILE $*      ;;
      *.rar)     rar $FILE $*      ;;
      *)         echo "Filetype not recognized" ;;
   esac
}

gitinfo () {
    git ls-tree -r HEAD|sed -re 's/^.{53}//'|while read filename; do file "$filename"; done|grep -E ': .*text'|sed -r -e 's/: .*//'|while read filename; do git blame "$filename"; done|sed -r -e 's/.*\((.*)[0-9]{4}-[0-9]{2}-[0-9]{2} .*/\1/' -e 's/ +$//'|sort|uniq -c
}

