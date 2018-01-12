bashelp
===

Offer help at the bash command prompt. Al Williams

Usage
---
. bashelp.sh

Near the start of the file is a line:
    bind -x '"\C-Y":_bash_help'

You can change the key from ^Y to something else by changing this line and sourcing the file again.

You may want to edit some of the other configuration parameters near the top:
* MANPGM - The name of your man program. Usually man unless you want a GUI (yelp, khelpcenter, gman, xman)
* PREFIX - If you need a prefix on the man topic (e.g., man:ls for ls, you set this to man:)
* MANOPT - If you need to pass an option to your man program (e.g., -H)
* TERMINAL - Set if using a CLI-based man (usually set to xterm)
* USEBROWSER - Set to 0 to run MANPGM in its own window
* SITE - If USEBROWSER=1 use a web browser to get the man page on the Internet (set up for http://man.he.net)
* SIZE - Size of terminal window (not used when TERMINAL is blank)

Common setups:
* Normal man in a new shell: MANPGM=man TERMINAL=xterm USEBROWSER=0 SIZE=132x48+0+0
* KDE Help: MANPGM=khelpcenter PREFIX=man: USEBROWSER=0
* Web: USEBROWSER=1 SITE="http://man.he.net/?section=all&topic="
* Local Browser: MANPGM=man MANOPT=-H USEBROWSER=1 BROWSER=google-chrome

