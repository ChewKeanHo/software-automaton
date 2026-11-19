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




# locate AUTOMATON_DIRECTORY.
# This is already set by the scanner Start.sh.ps1 script. Hence, no additional
# work is required.
#
# If it is unset, this means the script is operating using invalid method to
# initialize so it **MUST** be failed at all time.
if [ "$AUTOMATON_DIRECTORY" = "" ]; then
	1>&2 printf -- "%s" "\
E: '\$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

"
	return 1
elif [ "${AUTOMATON_DIRECTORY%"init.sh"}" = "$AUTOMATON_DIRECTORY" ]; then
	1>&2 printf -- "%s" "\
E: '\$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

"
	return 1
elif [ ! -f "$AUTOMATON_DIRECTORY" ]; then
	1>&2 printf -- "%s" "\
E: '\$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

"
	return 1
fi




# locate the AUTOMATON_DIRECTORY_ROOT App directory
AUTOMATON_DIRECTORY_ROOT="${AUTOMATON_DIRECTORY%"init.sh"}"
AUTOMATON_DIRECTORY_ROOT="${AUTOMATON_DIRECTORY_ROOT%"/"}"
AUTOMATON_DIRECTORY_ROOT="${AUTOMATON_DIRECTORY_ROOT%"presenters"}"
AUTOMATON_DIRECTORY_ROOT="${AUTOMATON_DIRECTORY_ROOT%"/"}"




# import libraries
if [ ! -f "${AUTOMATON_DIRECTORY_ROOT}/interactors/libraries/runtimes/load_modules.sh" ]; then
	1>&2 printf -- "%s" "\
E: 'runtimes/load_modules' -> ?!?!  <- Dev!!!

"
	return 1
fi

. "${AUTOMATON_DIRECTORY_ROOT}/interactors/libraries/runtimes/load_modules.sh"
command -v AUTOMATON_interactors_libraries_runtimes_load_modules \
	> /dev/null \
	2> /dev/null
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: 'AUTOMATON_interactors_libraries_runtimes_load_modules' -> ?!?!  <- Dev!!!

"
	return 1
fi

AUTOMATON_interactors_libraries_runtimes_load_modules \
	"${AUTOMATON_DIRECTORY_ROOT}/entities"
AUTOMATON_interactors_libraries_runtimes_load_modules \
	"${AUTOMATON_DIRECTORY_ROOT}/views"
AUTOMATON_interactors_libraries_runtimes_load_modules \
	"${AUTOMATON_DIRECTORY_ROOT}/interactors"




# configure console colors
AUTOMATON_COLOR_MODE="$( \
	AUTOMATON_interactors_libraries_os_read_terminal_color_mode \
)"




# configure app metadata
AUTOMATON_VERSION="$(AUTOMATON_interactors_responses_trademarks_get_version)"
AUTOMATON_LICENSE="$(AUTOMATON_interactors_responses_trademarks_get_license)"
AUTOMATON_LANG="$(AUTOMATON_interactors_libraries_os_read_lang)"




# save AUTOMATON_DIRECTORY_PWD current directory
AUTOMATON_DIRECTORY_PWD="$PWD"




# locate AUTOMATON_DIRECTORY_PROJECT directory
AUTOMATON_DIRECTORY_PROJECT="$PWD"
while true; do
	if [ "$AUTOMATON_DIRECTORY_PROJECT" = "/" ]; then
		AUTOMATON_interactors_libraries_os_print_error "\
'\$AUTOMATON_DIRECTORY_PROJECT' -> ?!?!  <- Dev!!!

" "$AUTOMATON_COLOR_MODE"
		return 1
	elif [ -d "${AUTOMATON_DIRECTORY_PROJECT}/.git" ]; then
		break
	fi

	AUTOMATON_DIRECTORY_PROJECT="${AUTOMATON_DIRECTORY_PROJECT%/*}"
done




# locate AUTOMATON_DIRECTORY_JOBS directory
AUTOMATON_DIRECTORY_JOBS="\
${AUTOMATON_DIRECTORY_JOBS:-"${AUTOMATON_DIRECTORY_PROJECT}/.internals/ci/jobs"}\
"
AUTOMATON_DIRECTORY_JOBS="${AUTOMATON_DIRECTORY_JOBS%/}"




# execute by first parameter
case "${1:-}" in
-h|help|Help|HELP)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/help/start.sh"
	return 0
	;;
license)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/license/start.sh"
	return 0
	;;
list)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/list/start.sh"
	return 0
	;;
run)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/run/start.sh"
	return 0
	;;
version)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/version/start.sh"
	return 0
	;;
*)
	AUTOMATON_interactors_libraries_os_print_error "\
'${1:-}' => ???
" "$AUTOMATON_COLOR_MODE"
	return 1
	;;
esac
