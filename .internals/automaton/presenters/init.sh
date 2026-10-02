#!/bin/sh
# Copyright 2026 The Automaton Project Team (https://github.com/ChewKeanHo/software-automaton)
#
# The above unified aliases have one or more actual legal entities listed
# outside of this document: (1) 'CREATORS.txt' or 'AUTHORS.txt'; and
# (2) 'CONTRIBUTORS.txt'. They are located usually placed next to this document
# in their respective project repository. Please refer to them for compiling the
# complete list accordingly.
#
#
# Zero-Clause BSD
# ===============
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
# FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
# DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
# AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
# OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.




# import libraries
AUTOMATON_Print_Error() {
	#____content="$1"
	#____color="$2"


	## !!! IMPORTANT NOTICE !!!
	## The variable names here are intentionally misspelled for avoiding
	## unwanted naming collision.


	# validate inputs
	_____runtime_x_retnirp_color=false
	case "${2:-}" in
	"")
		;;
	*[!0-9]*)
		;;
	*)
		if [ "$2" -ge "8" ]; then
			_____runtime_x_retnirp_color=true
		fi
		;;
	esac


	# execute
	printf -- "%s\n" "${1%"
"}" |
	while IFS="" read -r _____runtime_x_retnirp_line || \
	[ -n "$_____runtime_x_retnirp_line" ]; do
		if [ "$_____runtime_x_retnirp_color" = "true" ]; then
			1>&2 printf -- "%b%s%b\n" \
				"\\033[1;31mE:\\033[0m \\033[31m" \
				"${_____runtime_x_retnirp_line}" \
				"\\033[0m"
		else
			1>&2 printf -- "E: %s\n" "$_____runtime_x_retnirp_line"
		fi
	done
	unset _____runtime_x_retnirp_line _____runtime_x_retnirp_color


	# report status
	return 0
}


AUTOMATON_Print_Info() {
	#____content="$1"
	#____color="$2"


	## !!! IMPORTANT NOTICE !!!
	## The variable names here are intentionally misspelled for avoiding
	## unwanted naming collision.


	# validate inputs
	_____runtime_x_retnirp_color=false
	case "${2:-}" in
	"")
		;;
	*[!0-9]*)
		;;
	*)
		if [ "$2" -ge "8" ]; then
			_____runtime_x_retnirp_color=true
		fi
		;;
	esac


	# execute
	printf -- "%s\n" "${1%"
"}" |
	while IFS="" read -r _____runtime_x_retnirp_line || \
	[ -n "$_____runtime_x_retnirp_line" ]; do
		if [ "$_____runtime_x_retnirp_color" = "true" ]; then
			1>&2 printf -- "%b%s%b\n" \
				"\\033[1;36mI:\\033[0m \\033[36m" \
				"${_____runtime_x_retnirp_line}" \
				"\\033[0m"
		else
			1>&2 printf -- "I: %s\n" "$_____runtime_x_retnirp_line"
		fi
	done
	unset _____runtime_x_retnirp_line _____runtime_x_retnirp_color


	# report status
	return 0
}


AUTOMATON_Read_Terminal_Color_Mode() {
	# execute
	## try parse from $COLORTERM environment variable.
	case "${COLORTERM:-}" in
	truecolor|24bit|24-bit)
		printf -- "%s" 24
		return 0
		;;
	*)
		;;
	esac

	## try parse from tput command when available
	for ____runtime_command in "tput" \
	"/bin/tput" \
	"/usr/bin/tput" \
	"/usr/local/bin/tput"; do
		if [ "$____runtime_command" = "tput" ]; then
			command -v "$____runtime_command" \
				> /dev/null \
				2> /dev/null
			if [ $? -ne 0 ]; then
				continue
			fi
		else
			if [ ! -x "$____runtime_command" ]; then
				continue
			fi
		fi

		____runtime_color_count="$(\
			"$____runtime_command" colors 2> /dev/null \
		)"
		case "$____runtime_color_count" in
		-1)
			printf -- "%s" "1"
			unset ____runtime_color_count
			return 0
			;;
		''|*[!0-9]*)
			# error occured - try source from others
			unset ____runtime_color_count
			;;
		*)
			if [ "$____runtime_color_count" -ge 16777216 ]; then
				printf -- "%s" "24"
				unset ____runtime_color_count
				return 0
			elif [ "$____runtime_color_count" -ge 256 ]; then
				printf -- "%s" "8"
				unset ____runtime_color_count
				return 0
			elif [ "$____runtime_color_count" -ge 16 ]; then
				printf -- "%s" "4"
				unset ____runtime_color_count
				return 0
			elif [ "$____runtime_color_count" -ge 8 ]; then
				printf -- "%s" "3"
				unset ____runtime_color_count
				return 0
			else
				# unknown - try outer sources
				unset ____runtime_color_count
			fi
			;;
		esac
	done

	## try parse from $TERM environment variable.
	case "${TERM:-}" in
	vt100)
		printf -- "%s" "1"
		;;
	*-24bit|*-direct|*-truecolor)
		printf -- "%s" "24"
		;;
	*-256color|*-256colour|*256*|*kitty*)
		printf -- "%s" "8"
		;;
	xterm-16color|*-16color|*-16colour)
		printf -- "%s" "4"
		;;
	ansi|linux|console|eterm|rxvt|screen*|tmux*|\
	xterm*|vt???*|mlterm*|putty*|mintty*|st-*)
		printf -- "%s" "4"
		;;
	*)
		printf -- "%s" "1"
		;;
	esac


	# report status
	return 0
}




# configure console colors
AUTOMATON_COLOR_MODE="$(AUTOMATON_Read_Terminal_Color_Mode)"




# locate AUTOMATON_DIRECTORY.
# This is already set by the scanner Start.sh.ps1 script. Hence, no additional
# work is required.
#
# If it is unset, this means the script is operating using invalid method to
# initialize so it **MUST** be failed at all time.
if [ "$AUTOMATON_DIRECTORY" = "" ]; then
	AUTOMATON_Print_Error "\
'\$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

" "$AUTOMATON_COLOR_MODE"
	return 1
elif [ "${AUTOMATON_DIRECTORY%"init.sh"}" = "$AUTOMATON_DIRECTORY" ]; then
	AUTOMATON_Print_Error "\
'\$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

" "$AUTOMATON_COLOR_MODE"
	return 1
elif [ ! -f "$AUTOMATON_DIRECTORY" ]; then
	AUTOMATON_Print_Error "\
'\$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

" "$AUTOMATON_COLOR_MODE"
	return 1
fi




# save AUTOMATON_DIRECTORY_PWD current directory
AUTOMATON_DIRECTORY_PWD="$PWD"




# locate AUTOMATON_DIRECTORY_PROJECT directory
AUTOMATON_DIRECTORY_PROJECT="$PWD"
while true; do
	if [ "$AUTOMATON_DIRECTORY_PROJECT" = "/" ]; then
		AUTOMATON_Print_Error "\
'\$AUTOMATON_DIRECTORY_PROJECT' -> ?!?!  <- Dev!!!

" "$AUTOMATON_COLOR_MODE"
		return 1
	elif [ -d "${AUTOMATON_DIRECTORY_PROJECT}/.git" ]; then
		break
	fi

	AUTOMATON_DIRECTORY_PROJECT="${AUTOMATON_DIRECTORY_PROJECT%/*}"
done




# locate the localized AUTOMATON_DIRECTORY_ROOT App directory
if [ -f "${AUTOMATON_DIRECTORY_PROJECT}/.internals/automaton/app/presenters/init.sh" ]; then
	AUTOMATON_DIRECTORY_ROOT="${AUTOMATON_DIRECTORY_PROJECT}/.internals/automaton/app"
else
	AUTOMATON_DIRECTORY_ROOT="${AUTOMATON_DIRECTORY%"init.sh"}"
	AUTOMATON_DIRECTORY_ROOT="${AUTOMATON_DIRECTORY_ROOT%"/"}"
	AUTOMATON_DIRECTORY_ROOT="${AUTOMATON_DIRECTORY_ROOT%"presenters"}"
	AUTOMATON_DIRECTORY_ROOT="${AUTOMATON_DIRECTORY_ROOT%"/"}"
fi




# define all directory names
AUTOMATON_DIRECTORY_JOBS="\
${AUTOMATON_DIRECTORY_JOBS:-"${AUTOMATON_DIRECTORY_PROJECT}/.internals/ci/jobs"}\
"
AUTOMATON_DIRECTORY_JOBS="${AUTOMATON_DIRECTORY_JOBS%/}"


## setup relative ____job_location for error and help printout
____job_location="${AUTOMATON_DIRECTORY_JOBS##"$AUTOMATON_DIRECTORY_PWD"}"
if [ ! "$____job_location" = "$AUTOMATON_DIRECTORY_JOBS" ]; then
	____job_location="${____job_location#"/"}"
	____job_location="./${____job_location}"
fi




# execute by first parameter
case "${1:-}" in
run)
	if [ ! "$AUTOMATON_DIRECTORY_JOBS" = "" ] && [ ! "${2:-}" = "" ]; then
		if [ -f "${AUTOMATON_DIRECTORY_JOBS}/${2:-}/start.sh" ]; then
			({
				. "${AUTOMATON_DIRECTORY_JOBS}/${2:-}/start.sh"
				exit $?
			})
			return $?
		fi

		AUTOMATON_Print_Error "\
'${2:-}' = '${____job_location}/${2:-}/start.sh' => ???




" "$AUTOMATON_COLOR_MODE"
	fi
	;;
-h|help|Help|HELP)
	;;
*)
		AUTOMATON_Print_Error "\
'${1:-}' => ???




" "$AUTOMATON_COLOR_MODE"
	;;
esac




# print help
____jobs=""
if [ ! "${AUTOMATON_DIRECTORY_JOBS:-}" = "" ]; then
	if [ -d "${AUTOMATON_DIRECTORY_JOBS:-}" ]; then
		for ____item in "${AUTOMATON_DIRECTORY_JOBS:-}/"*; do
			if [ ! -e "$____item" ]; then
				continue
			fi

			if [ ! -d "$____item" ]; then
				continue
			fi

			if [ -f "${____item}/start.sh" ]; then
				____jobs="${____jobs}	* ${____item##*/}
"
			fi
		done

		____jobs="${____jobs%"
"}"
	fi
fi

if [ "$____jobs" = "" ]; then
	____jobs="----"
fi

	____message="\
(Holloway) Chew, Kean Ho's
_______ _     _ _______  _____  _______ _______ _______  _____  __   __
|_____| |     |    |    |     | |  |  | |_____|    |    |     | | \\\\  |
|     | |_____|    |    |_____| |  |  | |     |    |    |_____| |  \\\\_|
_________________________________________________________________________
v0.0.1
0bsd

$ [COMMAND] run [JOB] -> ${____job_location}/[JOB]/start.{sh,ps1}
$ [COMMAND] help
_________________________________________________________________________

[JOBS]:
${____jobs}


AUTOMATON_DIRECTORY_PWD:
${AUTOMATON_DIRECTORY_PWD}

AUTOMATON_DIRECTORY_PROJECT:
${AUTOMATON_DIRECTORY_PROJECT}

AUTOMATON_DIRECTORY_ROOT:
${AUTOMATON_DIRECTORY_ROOT}

AUTOMATON_COLOR_MODE:
${AUTOMATON_COLOR_MODE}
"
case "${1:-}" in
-h|help|Help|HELP)
	AUTOMATON_Print_Info "$____message" "$AUTOMATON_COLOR_MODE"
	return 0
	;;
*)
	AUTOMATON_Print_Error "$____message" "$AUTOMATON_COLOR_MODE"
	return 1
	;;
esac
