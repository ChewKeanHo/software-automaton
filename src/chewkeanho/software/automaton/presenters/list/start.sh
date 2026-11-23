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
if [ "$AUTOMATON_DIRECTORY_JOBS" = "" ]; then
	AUTOMATON_interactors_libraries_os_print_error "\
\$AUTOMATON_DIRECTORY_JOBS => ???
" "$AUTOMATON_COLOR_MODE"
	return 1
fi




## scan directory
____jobs_list=""
for ____job in "${AUTOMATON_DIRECTORY_JOBS}/"*; do
	if [ ! -d "$____job" ]; then
		continue
	fi

	if [ ! -f "${____job}/start.sh" ]; then
		continue
	fi

	if [ ! -f "${____job}/start.ps1" ]; then
		continue
	fi

	____job="${____job##*/}"

	____jobs_list="\
${____jobs_list}${____job}
"
done
unset ____job
____jobs_list="${____jobs_list%"
"}"




# report status
printf -- "%s\n" "$____jobs_list"
if [ $? -ne 0 ]; then
	unset ____jobs_list
	return 1
fi
unset ____jobs_list
return 0
