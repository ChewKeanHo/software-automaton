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




# Description:
# 'AUTOMATON_interactors_libraries_encodings_conf_read_file' is to read a
# configuration file for its value.
# Parameters:
#	(1) Filepath				REQUIRED.
#						The filepath to read the .conf
#						file.
#	(2) Name				REQUIRED.
#						The variable name from the
#						confgiuration file.
# Outputs:
#	(1) Environment Variable Set		The environment variable is set
#						to the value of the file against
#						the given name as its name.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
#	'2'
#		* missing filepath.
#	'3'
#		* invalid filepath.
#	'4'
#		* missing name.
#	'5'
#		* invalid name.
#	'6'
#		* mismatched variable name.
#	'1'
#		* bad exec
AUTOMATON_interactors_libraries_encodings_conf_read_file() {
	#____filepath="$1"
	#____name="$2"


	# validate inputs
	if [ "${1:-}" = "" ]; then
		return 2
	fi

	if [ ! -f "${1:-}" ]; then
		return 3
	fi

	case "${2:-}" in
	"")
		return 4
		;;
	*[a-z]*)
		return 5
		;;
	[0-9]*)
		return 5
		;;
	*[!A-Z_])
		return 5
		;;
	*)
		;;
	esac


	# execute
	____interactors_parse_state="opener"
	____interactors_parsed_value=""
	while IFS="" read -r ____line || [ -n "$____line" ]; do
		case "${____line%%"#"*}" in
		"")
			# do nothing
			;;
		*' = """')
			case "$____interactors_parse_state" in
			opener)
				____interactors_parse_state="content"
				;;
			*)
				return 1
				;;
			esac

			case "${____line%%" = "*}" in
			"${2:-}")
				;;
			*)
				return 6
				;;
			esac
			;;
		'"""')
			case "$____interactors_parse_state" in
			content)
				____interactors_parse_state="end"
				break
				;;
			*)
				return 1
				;;
			esac
			;;
		*)
			case "$____interactors_parse_state" in
			content)
				____interactors_parsed_value="\
${____interactors_parsed_value}${____line}
"
				;;
			*)
				# do nothing
				;;
			esac
			;;
		esac
	done < "${1:-}"
	unset ____line


	# report status
	case "$____interactors_parse_state" in
	end)
		export "${2:-}"="${____interactors_parsed_value%"
"}"
		unset ____interactors_parse_state ____interactors_parsed_value
		return 0
		;;
	*)
		export "${2:-}"=""
		unset ____interactors_parse_state ____interactors_parsed_value
		return 1
		;;
	esac
}




# report import status
return 0
