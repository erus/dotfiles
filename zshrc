[ -z "$PS1" ] && return

welcome_arch () {
DISTRO="\e[1;36mArch\e[1;37mLinux\e[;0m"
SLOGAN=`shuf -n 1 ~/.slogan.lst`
SIZE=$(echo 10+`echo "$SLOGAN" | wc -c` | bc)
if [ $COLUMNS -gt $SIZE ] ; then
SPACE="`for i in $(seq $SIZE $COLUMNS) ; do echo -n ' ' ; done`"
else
unset SPACE SLOGAN
fi
echo "$DISTRO$SPACE$SLOGAN"
for i in DISTRO SPACE SLOGAN ; do unset $i ; done
}
#You'll have to adapt next line.
[ -z "$DISPLAY" ] || [ "`wmfs -g layout`" = 'Current layout:  \i[9;5;9;7;~/.config/wmfs/wh/tg.png]\' ] || welcome_arch
trap clear EXIT

setopt extendedglob
setopt correct
setopt hist_ignore_dups
setopt hist_expire_dups_first
unsetopt list_ambiguous

bindkey -e

autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

PROMPT="%f%(!.#.β) "
RPROMPT="%(?..%F{red}!%?!%f%F{white}:)%~%(1j.:%j.)%f"

. ~/.zprofile

autoload -U url-quote-magic; zle -N self-insert url-quote-magic
zstyle -e :urlglobber url-other-schema \
      '[[ $words[1] == scp ]] && reply=("*") || reply=(http https ftp)'

zmodload zsh/complist

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

zstyle :compinstall filename '/home/erus/.zshrc'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:cp:*' ignore-line yes
zstyle ':completion:*:mv:*' ignore-line yes
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache

compdef pacman-color=pacman
compdef yaourt=pacman

alias asciiportal='cd /opt/asciiportal ; ./ASCIIpOrtal -r 1024x768 $* ; cd -'
alias busy='my_file=$(find /usr/include -type f | sort -R | head -n 1); my_len=$(wc -l <$my_file); let "r = $RANDOM % $my_len" 2>/dev/null; vim +$r $my_file'
alias c='clear'
alias df='df -h'
alias du='du -h'
alias emacs='emacs -nw'
alias epoch='date +%s'
alias fehbgs='feh --bg-scale'
alias fehbgc='feh --bg-center'
alias pr0n='mplayer -idx -af volnorm -vo vdpau,deint=4,colorspace=0 &> /dev/null'
alias pr0n_fb='mplayer -idx -af volnorm -vo fbdev -geometry 50%:50% &> /dev/null'
alias film='mplayer -idx -fs -af volnorm -vo vdpau,deint=4,colorspace=0 &> /dev/null'
alias film_fb='mplayer -idx -fs -af volnorm -vo fbdev &> /dev/null'
alias flat='df ; ls -FlAt | head -n 25'
alias flood='date +'%H:%M:%S' ; hping3 --flood -a 127.0.0.1 -e “DISCORDIA” -k -p 80 -s 80 -S'
alias fraps='ffmpeg -f x11grab -s 1440x900 -r 25 -i :0.0 -sameq /tmp/out.mpg'
alias heure='tty-clock -cs'
alias icanhazip='curl http://icanhazip.com/'
#alias icanhazip='curl http://whatismyip.org/'
alias lastlogs='last -a'
alias less='less -R'
alias ls='ls --classify --tabsize=0 --literal --color=always --show-control-chars --human-readable'
alias ll='ls -lh --classify --tabsize=0 --literal --color=always --show-control-chars --human-readable'
alias lla='ls -lah --classify --tabsize=0 --literal --color=always --show-control-chars --human-readable'
alias logs='ccze -A'
alias mtr='mtr -t'
alias pacman='pacman-color'
alias scan='sudo iwlist wlan0 scan'
alias screen='screen -RaAD'
alias skoi='file'
alias tree='tree -C'
alias upgrade='sudo abs && yaourt -Syu --aur --devel'
alias veille='sudo pm-suspend'
alias whene='when e'
alias zoli='column -t'
alias zshrc='nano /home/erus/.zshrc && . /home/erus/.zshrc'

alias -s png=feh
alias -s jpg=feh
alias -s gif=feh
alias -s eps=feh
alias -s pdf=evince
alias -s sxw=soffice
alias -s doc=soffice
alias -s xls=soffice
alias -s ppt=soffice
alias -s odt=soffice
alias -s txt=$EDITOR
alias -s tex=$EDITOR
alias -s install=$EDITOR

rc_daemon () { ls /etc/rc.d/ }
rc_restart () { sudo /etc/rc.d/$1 restart }
rc_reload () { sudo /etc/rc.d/$1 reload }
rc_start () { sudo /etc/rc.d/$1 start }
rc_stop () { sudo /etc/rc.d/$1 stop }
cp_p () {
   strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
      | awk '{
        count += $NF
            if (count % 10 == 0) {
               percent = count / total_size * 100
               printf "%3d%% [", percent
               for (i=0;i<=percent;i++)
                  printf "="
               printf ">"
               for (i=percent;i<100;i++)
                  printf " "
               printf "]\r"
            }
         }
         END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}
duration () { ffmpeg -i "$@" 2>&1 | sed '/Duration/!d;s/\  //;s/\,.*//g' }
ecran () {
case "$1" in
        stop)
        xset dpms force standby ;;
        start)
        xset dpms force on
        xset s reset  ;;
        *)
        echo "Usage: $0 {start|stop}"
esac
}
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvf $1     ;;
          *.tar.gz)    tar xvf $1     ;;
          *.tar.xz)    tar xvf $1     ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvf $1     ;;
          *.tgz)       tar xvf $1     ;;
          *.bz2)       bunzip2 $1     ;;
          *.gz)        gunzip $1      ;;
          *.rar)       unrar x $1     ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}
flv2mp3 () {
if [ $# != 1 ]
then
  echo Usage: $0 inputfile >&2
  exit 1
fi
if [ $1 -ne *.flv ]
then
  echo FLV file expected!
  echo Usage: $0 inputfile >&2
  exit 1
fi
FILNAME=${1%.[^.]*}
mplayer "$1" -vo null -ao pcm:file="$FILNAME.wav"
lame --preset standard "$FILNAME.wav" "$FILNAME.mp3"
#rm "$FILNAME.wav"
}
google () {
if [ $# -ne 0 ]; then
	keywords=$(echo $* | sed s/\ /+/g)
	elinks "http://www.google.com/search?q=${keywords}&ie=utf-8&oe=utf-8"
else
	echo "usage: $(basename $0) keyword1 [keyword2 ... [keywordN]]"
	echo " $(basename $0) word1 OR word2 - search for any of given keywords"
	echo " $(basename $0) word1 AND word2 - search for both given keywords"
	exit 1
fi
}
mkcdir () { mkdir -p $1 && cd $1 }
mktar () { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz () { tar -cf - "${1%%/}" | pv -bpet | gzip > "${1%%/}.tar.gz" }
mktbz () { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }
save () { cp $1 $1.save }
say () { echo $* | text2wave | aplay }
translate () { wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/'; }
wiki () { dig +short txt $1.wp.dg.cx }
xkcd () { local f;f=$(curl -s http://xkcd.com/);display $(echo "$f"|grep -Po '(?<=")http://imgs.xkcd.com/comics/[^"]+(png|jpg)');echo "$f"|awk '/<img src="http:\/\/imgs\.xkcd\.com\/comics\/.*?" title=.*/{gsub(/^.*title=.|".*?$/,"");print}';}
xkcdrandom () { local f;f=$(wget -q http://dynamic.xkcd.com/comic/random/ -O -);display $(echo "$f"|grep -Po '(?<=")http://imgs.xkcd.com/comics/[^"]+(png|jpg)');echo "$f"|awk '/<img src="http:\/\/imgs\.xkcd\.com\/comics\/.*?" title=.*/{gsub(/^.*title=.|".*?$/,"");print}';}
meteo () {
METEO=`lynx -width=230 -dump "http://fr.weather.com/weather/10dayPrinterFriendly-Paris-FRXX0076" | head -n 33 | tail -n 13`
MAJ=`lynx -width=230 -dump "http://fr.weather.com/weather/10dayPrinterFriendly-Paris-FRXX0076" | grep mise | cut -d '(' -f 1`
LUNE=`lynx -width=230 -dump "http://www.calendrier-lunaire.net/" | tail -n 60 | head -n 11 | sed 's/     \*/  /g;s/Pr/   Pr/'`
SOLEIL=`lynx -width=230 -dump "http://www.timeanddate.com/worldclock/astronomy.html?n=195" | head -n 50 | tail -n 11 | sed 's/                                                                          //g'`
echo $METEO "\n"
echo $MAJ
echo $LUNE "\n"
echo $SOLEIL
}
youtube_play () { wget -q -O - `youtube-dl -b -g $1`| ffmpeg -i - -f mp3 -vn -acodec libmp3lame - | mpg123  - }

alias grep='grep --color=auto'

bindkey '^A'    beginning-of-line       # Home
bindkey '^E'    end-of-line             # End
bindkey '[2~' overwrite-mode          # Insert
bindkey '[3~' delete-char             # Del
bindkey '[5~' history-search-backward # PgUp
bindkey '[6~' history-search-forward  # PgDn

case $TERM in
    xterm*)
        precmd () { print -Pn "\e]0;%y:%n@%M\a" ; rehash }
        bindkey '[H'  beginning-of-line
        bindkey '[F'  end-of-line
    ;;
    rxvt*)
        precmd () { print -Pn "\e]0;%y:%n@%M\a" ; rehash }
        bindkey '^[[7~' beginning-of-line
        bindkey '^[[8~' end-of-line
    ;;
    linux)
        precmd () { rehash }
        bindkey '^[[1~' beginning-of-line
        bindkey '^[[4~' end-of-line
    ;;
    screen*)
        precmd () { rehash }
        bindkey '^[[1~' beginning-of-line
        bindkey '^[[4~' end-of-line
    ;;
esac

if [ $(tty) = "/dev/tty1" ]; then
  xinit 1> /dev/null 2>&1
  logout
fi
