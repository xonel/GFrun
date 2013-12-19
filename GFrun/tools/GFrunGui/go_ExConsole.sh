#!/bin/bash
cd "$( cd "$(dirname $0)"; pwd )"
if ! type glade2script; then
    G2S="./glade2script"
else
    G2S=glade2script
fi
$G2S -g ./ExConsole.glade -d --terminal='_hbox1:900x300' \
--terminal-redim --terminal-font='serif,monospace bold condensed 10' \
--auto-config=config.cfg
exit
