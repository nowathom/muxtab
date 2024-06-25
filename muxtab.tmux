#!/bin/sh

# shellcheck source-path=SCRIPTDIR/src
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
SCRIPTS_PATH="$CURRENT_DIR/src"
. "$SCRIPTS_PATH/helpers.sh"

timer="#($SCRIPTS_PATH/timer.sh)"

set_tmux_option "@muxtab_file" "$HOME/.muxtab"

set_tmux_option "status-left" "$timer$(get_tmux_option "status-left" "")"
