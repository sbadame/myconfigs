#The virtualenvwrapper magic happens at the end of the file since the
#prompt needs to be defined first...

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

#Colors from: https://wiki.archlinux.org/index.php/Color_Bash_Prompt
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

#Just for the tools that like to modify the prompt, it's good to have a variable without newlines.
#(lookin at you virtualenv)
export SIMPLE_PROMPT="\[$bakwht\]\[$bldblk\]\$(getShrunkenPWD) \[$txtrst\]\[$bldwht\]\[$bldwht\]\$(get_git_info)\[\e[00m\]"
PS1="\n${SIMPLE_PROMPT} \n> "

#################################################################################
#            Same handy functions....
#################################################################################

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
            *.jar)       jar xf $1     ;;
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

gitblamer() {
    echo "Commits per commiter"
    git shortlog -s
    commiters=$(git shortlog -s | cut -f2)
    declare -A linecounts
    for commiter in $commiters
    do
        linecounts[$commiter]="0"
    done

    for file in $(git ls-files | grep "\.\(py\|html\|java\|cpp\|c\)$")
    do
        for commiter in $commiters
        do
            #echo "$(git blame $file | grep $commiter | wc -l)"
            #echo "${linecounts[$commiter]}"
            linecount=$(git blame $file | grep $commiter | wc -l)
            linecounts[$commiter]=$(expr ${linecounts[$commiter]} + $linecount)
        done
    done

    echo -e "\nLines of Code per commiter"
    for commiter in $commiters
    do
        echo "$commiter ${linecounts[$commiter]}"
    done
}

gitinfo () {
    git ls-files | while read filename; do file "$filename"; done|grep -E ': .*text'|sed -r -e 's/: .*//'|while read filename; do git blame "$filename"; done|sed -r -e 's/.*\((.*)[0-9]{4}-[0-9]{2}-[0-9]{2} .*/\1/' -e 's/ +$//'|sort|uniq -c
}

rgrep () {
    find . -type f -exec grep -Hni $@ {} \;
}

if [[ -f ~/.my_aliases ]]; then
    source ~/.my_aliases;
fi

# This needs to happen AFTER the prompt is set.
if [[ -f /usr/bin/virtualenvwrapper.sh ]]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/bin/virtualenvwrapper.sh
    if [[ -f $VIRTUALENVWRAPPER_HOOK_DIR/currentvirtualenv ]]; then
        lastdir=$PWD
        workon `cat ${VIRTUALENVWRAPPER_HOOK_DIR}/currentvirtualenv`
        cd $lastdir
    fi
fi
