#!/bin/sh

# shellcheck source-path=SCRIPTDIR
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
SCRIPTS_PATH="$CURRENT_DIR"
. "$SCRIPTS_PATH/helpers.sh"

LOCKFILE="/tmp/muxtab.timer.lock"

main() {
	if [ -e ${LOCKFILE} ] && kill -0 "$(cat ${LOCKFILE})" 2>/dev/null; then
		# another timer is running
		exit 0
	fi

	trap 'rm -f ${LOCKFILE}; exit 0' INT TERM EXIT
	echo $$ >${LOCKFILE}

	current_time=$(date +%s)

	muxtab_file=$(get_tmux_option "@muxtab_file" "$HOME/.muxtab")

	if [ ! -e "$muxtab_file" ]; then
		# no muxtab file found
		exit 0
	fi

	# loop through the muxtab file
	while read -r line; do
		# remove leading whitespaces
		cleaned_line=$(echo "$line" | sed -e 's/^[[:space:]]*//')
		# skip empty lines
		if [ -z "$cleaned_line" ]; then
			continue
		fi

		# skip comments
		case "$cleaned_line" in
		\#*) continue ;;
		esac

		# split line into interval and command
		set -- "$cleaned_line"
		interval=$(echo "$cleaned_line" | awk '{print $1}')
		command=$(echo "$cleaned_line" | awk '{$1=""; print $0}' | sed -e 's/^[[:space:]]*//')

		# check if the command is due to be run
		hash=$(echo "$command" | sha256sum | cut -d' ' -f1)
		if [ -e "/tmp/muxtab.timer.$hash" ]; then
			last_time=$(cat "/tmp/muxtab.timer.$hash")
			if [ $((last_time + interval)) -gt "$current_time" ]; then
				# not due yet
				continue
			fi
		fi

		# run command
		echo "$current_time" >"/tmp/muxtab.timer.$hash"
		eval "$command" &

	done <"$muxtab_file"

	rm -f ${LOCKFILE}
}

main
