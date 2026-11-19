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
if [ ! "$AUTOMATON_DIRECTORY_JOBS" = "" ] && [ ! "${2:-}" = "" ]; then
	if [ -f "${AUTOMATON_DIRECTORY_JOBS}/${2:-}/start.sh" ]; then
		({
			. "${AUTOMATON_DIRECTORY_JOBS}/${2:-}/start.sh"
			exit $?
		})
		return $?
	fi
fi




# default action
____job_location="${AUTOMATON_DIRECTORY_JOBS##"$AUTOMATON_DIRECTORY_PWD"}"
if [ ! "$____job_location" = "$AUTOMATON_DIRECTORY_JOBS" ]; then
	____job_location="${____job_location#"/"}"
	____job_location="./${____job_location}"
fi


AUTOMATON_Print_Error "\
'${2:-}' = '${____job_location}/${2:-}/start.sh' => ???
" "$AUTOMATON_COLOR_MODE"
return 1
