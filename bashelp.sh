# source this and bind it to get context help on the shell
# here's a bind line to get you started
# Bind to ^Y although obviously you could pick something else
bind -x '"\C-Y":_bash_help'

_bash_help () {
    # Program used to show man pages, probably man or some graphical man reader
    local manpgm=${BASHELP_MANPGM-man}
    # Prefix added to all man page names, needed for some GUI man readers like
    # yelp or khelpcenter
    local prefix=${BASHELP_PREFIX-}
    # Options passed to manpgm
    local manopt=${BASHELP_MANOPT-}
    # The terminal to run manpgm in, or null if using a GUI manpgm
    local terminal=${BASHELP_TERMINAL-xterm}
    # Options passed to a graphical terminal
    local termopt=${BASHELP_TERMOPT-}
    # Set to 0 to use terminal or GUI, other to use web browser
    local usebrowser=${BASHELP_USEBROWSER-0}
    # URL prefix added to man page names to open man pages from a website
    local site=${BASHELP_SITE-}

# If we got called with no readline, forget it
    if [ -z "$READLINE_LINE" ]
    then
	return
    fi

# Don't try to help people in a console/TTY if terminal isn't known to work
    case $terminal in
        man) ;;
        screen) ;;
        tmux) ;;
        *)
            if [ -z "$DISPLAY" ]
            then
                return
            fi
            ;;
    esac

    # Get command up to the cursor
    local token="${READLINE_LINE:0:${READLINE_POINT}}"
    # Remove everything before the last pipe
    token=${token##*|}
    # Strip leading whitespace
    token="$(echo -e "${token}" | sed -e 's/^[[:space:]]*//')"
    # Get the first word of token
    local cmd=${token%% *}
    # If we don't know about this program, skip it
    # don't redirect stderr since that is helpful
    # we assume the system man knows about everything the other man programs might know
    if ! man -w "$cmd" >/dev/null
    then
	return
    fi

    # Check special cases
    if [ "$cmd" = "btrfs" -o "$cmd" = "flatpak" -o "$cmd" = "git" -o "$cmd" = "openssl" -o "$cmd" = "ostree" ]
    then
        local token_no_cmd=${token#* }
        local subcmd=${token_no_cmd%% *}
        # If there's a manual for this subcommand, use that as cmd
        if man -w "$cmd-$subcmd" &>/dev/null
        then
            cmd="$cmd-$subcmd"
        fi
    fi

# construct command
    local cmd_pref="$prefix$cmd"

    if [ "$usebrowser" == 0 ]
    then
        case $terminal in
            "")
                ( "$manpgm" $manopt "$cmd_pref" &) &>/dev/null   # must be a GUI man?
                ;;
            gnome-terminal)
                "$terminal" $termopt -- $manpgm "$cmd_pref"
                ;;
            man)
                $manpgm "$cmd_pref"
                ;;
            screen)
                "$terminal" $manpgm "$cmd_pref"
                ;;
            tmux)
                "$terminal" new-window $manpgm "$cmd_pref"
                ;;
            *)
                # execute without job control noise
                ("$terminal" $termopt -e "$manpgm \"$cmd_pref\"; exit" &)
                ;;
        esac
    else
	if [ -z "$site" ]
	then
	    ("$manpgm" $manopt "$cmd_pref" &) &>/dev/null  # catch messages from browser & job control
	else
# if you are more a web kind of guy/gal try this
	    ( xdg-open "$site$cmd" &)
	fi
    fi
    }

