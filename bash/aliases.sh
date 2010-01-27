# general shortcuts
alias c='cd '
alias mv='mv -i'
alias rm='rm -i'
alias :='cd ..'
alias ::='cd ../..'
alias :::='cd ../../..'
alias md=mkdir

# Need to do this so you use backspace in screen...I have no idea why
alias screen='TERM=screen screen'

# listing files
alias l='ls -al'
alias ltr='ls -ltr'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'

# editing shortcuts
alias m='mate'
alias e='emacs'
alias erc='e /etc/bashrc'
alias newrc='. /etc/bashrc'
alias rsync_novc="rsync --exclude=.svn --exclude=.git -r "

# grep for a process
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# Mac style apache control
# TODO init this style of aliases for darwin arch
# alias htstart='sudo /System/Library/StartupItems/Apache/Apache start'
# alias htrestart='sudo /System/Library/StartupItems/Apache/Apache restart'
# alias htstop='sudo /System/Library/StartupItems/Apache/Apache stop'

# Debian style apache control
alias htreload='sudo /etc/init.d/apache2 reload'
alias htrestart='sudo /etc/init.d/apache2 restart'
alias htstop='sudo /etc/init.d/apache2 stop'

alias cycle_passenger='touch tmp/restart.txt'

# top level folder shortcuts
alias src='cd ~/src'
alias docs='cd ~/documents'
alias scripts='cd ~/src/scripts'

alias h?="history | grep "

# display battery info on your Mac
# see http://blog.justingreer.com/post/45839440/a-tale-of-two-batteries
alias battery='ioreg -w0 -l | grep Capacity | cut -d " " -f 17-50'
