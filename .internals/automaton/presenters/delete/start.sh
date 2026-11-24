#!/bin/sh
# Copyright 2026 The Automaton Project Team (https://doi.org/10.5281/zenodo.23129070)
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




# check $AUTOMATON_DIRECTORY_JOBS validity
if [ "$AUTOMATON_DIRECTORY_JOBS" = "" ]; then
	AUTOMATON_interactors_libraries_os_print_error "\
\$AUTOMATON_DIRECTORY_JOBS => ???
" "$AUTOMATON_COLOR_MODE"
	return 1
fi




# check [JOB] validity
if [ "${2:-}" = "" ]; then
	AUTOMATON_interactors_libraries_os_print_error "\
[JOB] => ???
" "$AUTOMATON_COLOR_MODE"
	return 1
fi




# check existing entry
if [ ! -e "${AUTOMATON_DIRECTORY_JOBS}/${2:-}" ]; then
	AUTOMATON_interactors_libraries_os_print_error "\
'${AUTOMATON_DIRECTORY_JOBS}/${2:-}' => ???
" "$AUTOMATON_COLOR_MODE"
	return 1
fi




## delete target
AUTOMATON_interactors_libraries_fs_delete \
	"${AUTOMATON_DIRECTORY_JOBS}/${2:-}" \
	"true"
if [ $? -ne 0 ]; then
	AUTOMATON_interactors_libraries_os_print_error "\
'${AUTOMATON_DIRECTORY_JOBS}/${2:-}' => !!!
" "$AUTOMATON_COLOR_MODE"
	return 1
fi




# report status
return 0
