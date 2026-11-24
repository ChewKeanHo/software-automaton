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




# Description:
# `AUTOMATON_interactors_libraries_os_print_success` is to print a given
# intepreted content into the terminal's STDERR console.
#
# The content is printed success when color is enabled.
# Parameters:
#	(1) Content		REQUIRED.
#				The interpreted string content. Multi-line is
#				supported.
#	(2) Color		OPTIONAL.
#				Flag to enable color mode. Accepts number. 8 and
#				above will turn the color on.
#
#				Default is monochrome.
#
# Outputs:
#	(1) Printed String	The content is printed onto terminal's STDERR
#				console.
#
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
AUTOMATON_interactors_libraries_os_print_success() {
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
				"\\033[1;32mS:\\033[0m \\033[32m" \
				"${_____runtime_x_retnirp_line}" \
				"\\033[0m"
		else
			1>&2 printf -- "S: %s\n" "$_____runtime_x_retnirp_line"
		fi
	done
	unset _____runtime_x_retnirp_line _____runtime_x_retnirp_color


	# report status
	return 0
}




# report import status
return 0
