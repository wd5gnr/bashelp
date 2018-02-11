bashelp
===

Offer help at the bash command prompt. Al Williams

Usage
---

    . bashelp.sh

Near the start of the file is a line:

    bind -x '"\C-Y":_bash_help'

You can change the key from <kbd>Ctrl</kbd> + <kbd>Y</kbd> to something else by
changing this line and sourcing the file again.

Options
-------

The way that bashelp shows man pages can be configured through environment
variables, without modifying the script itself.  The default settings, shown
below, tell bashelp to run man in an xterm:

    BASHELP_MANPGM=man
    BASHELP_TERMINAL=xterm
    BASHELP_USEBROWSER=0

Supported values for `BASHELP_TERMINAL` are:

* `man` (runs man in the current terminal)
* `screen` (shows man pages in a new window of GNU Screen)
* `tmux` (shows man pages in a new window of tmux)
* `gnome-terminal`
* Any terminal that takes the same command-line options as xterm

Graphical terminals can be passed additional options using `BASHELP_TERMOPT`.

Or, you can run a GUI man reader like yelp by setting:

    BASHELP_MANPGM="yelp"
    BASHELP_PREFIX="man:"
    BASHELP_TERMINAL=
    BASHELP_USEBROWSER=0

Or, you can open a web site using the default web browser by setting:

    BASHELP_USEBROWSER=1
    BASHELP_SITE="http://man.he.net/?section=all&topic=" #(or equivalent)

Or, you can open a local man page in a browser by setting:

    BASHELP_MANPGM=man
    BASHELP_USEBROWSER=1
    BASHELP_SITE=
    BASHELP_MANOPT="-H "
    BROWSER=google-chrome
