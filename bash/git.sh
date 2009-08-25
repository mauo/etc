# Thanks to Geoffrey's peepcode for many of these
alias gst='git status'
alias gs='git status'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gr='git remote -v'
alias gb='git branch -a'
alias gdc='git diff --cached'

# git rm files that have already been deleted.
alias git_rmd='git ls-files -d | ruby -ne "puts \$_.gsub(/ /, \"\\\\ \")" | xargs git rm'

alias gra='git_remote_add'
