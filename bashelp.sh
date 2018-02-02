# source this and bind it to get context help on the shell
# here's a bind line to get you started
# Bind to ^Y although obviously you could pick something else
bind -x '"\C-Y":_bash_help'


_bash_help () {
    # Options
    # You can run man in an xterm (or equivalent) by setting MANPGM=man and TERMINAL=xterm and USEBROWSER=0
    # Or, you can run something like yelp by setting MANPGM="yelp", PREFIX="man:" TERMINAL= and USEBROWSER=0
    # Or, you can open a web site by setting USEBROWSER=1 and SITE=http://man.he.net (or equivalent)
    # Or, you can open a local man page in browser by setting MANPGM=man, USEBROWSER=1, SITE=, MANOPT="-H "

    # Summary:
    # normal - MANPGM=man TERMINAL=xterm USEBROWSER=0
    # gui - MANPGM=yelp TERMINAL= USEBROWSER=0 PREFIX=man:
    # web - USEBROWSER=1 SITE="http://man.he.net/?section=all&topic="
    # local browser - USEBROWSER=1 MANPGM=man SITE= MANOPT=-H
    
    MANPGM=man
    # Prefix is usually empty, but if you need to pass something like man: to yelp or khelpcenter
    PREFIX=
    # MANOPT is usually empty unless you need to pass -H to man or some other option
    MANOPT=
    # If using a GUI MANPGM (yelp, gman, etc.) Set TERMINAL to blank (TERMINAL=)
    # Set TERMINAL=screen to show man pages in the current terminal with GNU Screen
    # Other terminals must accept the same options as xterm
    TERMINAL=xterm

    USEBROWSER=0    # set 0 to use terminal or GUI, other to use web browser

    # Set SITE="http://man.he.net/?section=all&topic="
    # if you want to open local man pages in your browser (see below)
    # or you can use this or equivalent
    SITE=
# if USEBROWSER=1 and SITE= this needs to be set
    BROWSER=google-chrome
    # set size for X terminal
    SIZE=132x48+0+0   # size (columns,rows,X,Y)

    # Nothing to change below here

# If we got called with no readline, forget it
    if [ -z "$READLINE_LINE" ]
    then
	return
    fi

# Don't try to help people in a console/TTY if TERMINAL isn't known to work
    case $TERMINAL in
        screen)
            ;;
        *)
            if [ -z "$DISPLAY" ]
            then
                return
            fi
            ;;
    esac

# Get command name
    TOKEN="${READLINE_LINE:0:${READLINE_POINT}}"
# find first part of command line
    CMD=${TOKEN%% *}
    # If we don't know about this program, skip it
    # don't redirect stderr since that is helpful
    # we assume the system man knows about everything the other man programs might know
    if ! man -w "$CMD" >/dev/null
    then
	return
    fi

    if [ "$USEBROWSER" == 0 ]
    then
        case $TERMINAL in
            "")
                ( "$MANPGM" $MANOPT "$PREFIX$CMD" &) &>/dev/null   # must be a GUI man?
                ;;
            screen)
                "$TERMINAL" $MANPGM "$PREFIX$CMD"
                ;;
            *)
                # execute without job control noise
                ("$TERMINAL" -geometry "$SIZE" -e "$MANPGM \"$PREFIX$CMD\"; exit" &)
                ;;
        esac
    else
	if [ -z "$SITE" ]
	then
	    export BROWSER
	    ("$MANPGM" $MANOPT "$PREFIX$CMD" &) &>/dev/null  # catch messages from browser & job control
	else
# if you are more a web kind of guy/gal try this
	    ( xdg-open "$SITE$CMD" &)
	fi
    fi
    }

