alias u="svn up --ignore-externals"
alias new='svn st | grep "^?" | cut -d " " -f 7'
alias conflicts='svn st | grep "^C" | cut -d " " -f 7'
alias deletes='svn st | grep "^D" | cut -d " " -f 7'
alias mods='svn st | grep "^M" | cut -d " " -f 7'
alias addnew='new | cut -d " " -f 7 | xargs svn add'
alias addr='find . -not -path *.svn* | xargs svn add'

# stupid aliases for trying to get useful information from svn logs...
alias rlog='svn log | ruby -e"data = []; while l = gets; data << l; (puts data.join; data = []) if l =~ /----------/; end; puts data.join"'
alias rmylog='svn log | ruby -e"data = []; while l = gets; data << l; (puts data.join; data = []) if l =~ /----------/ && data.first =~ /${SVN_USER}/; end; puts data.join"'
alias rnotmylog='svn log | ruby -e"data = []; while l = gets; data << l; (puts data.join; data = []) if l =~ /----------/ && data.first !~ /${SVN_USER}/; end; puts data.join"'
alias rvlog='svn log -v | ruby -e"data = []; while l = gets; data << l; (puts data.join; data = []) if l =~ /----------/; end; puts data.join"'
alias rmyvlog='svn log -v | ruby -e"data = []; while l = gets; data << l; (puts data.join; data = []) if l =~ /----------/ && data.first =~ /${SVN_USER}/; end; puts data.join"'
