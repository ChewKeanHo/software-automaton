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
#	`AUTOMATON_interactors_responses_licenses_render_license_notice` is to
#	render the application's license notice.
# Parameters:
#	(1) Comment Prefix	OPTIONAL.
#				The comment prefix. Empty means raw rendering.
# Outputs:
#	(1) Rendered String	The rendered license string.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means any of the given input is empty.
#	'1'
#		*	means bad execution.
AUTOMATON_interactors_responses_licenses_render_license_notice() {
	#____comment_prefix="$1"


	# execute
	## parse the data file
	____output=""
	while IFS="" read -r ____output_line || [ -n "$____output_line" ]; do
		____output_prefix="${1:-}"
		if [ "$____output_line" = "" ]; then
			while [ ! "$____output_prefix" = "" ]; do
				case "${____output_prefix##"${____output_prefix%?}"}" in
				" "|"	")
					____output_prefix="${____output_prefix%?}"
					;;
				*)
					break
					;;
				esac
			done
		fi

		____output="\
${____output}${____output_prefix}${____output_line}
"
	done<<EOF
$( \
	AUTOMATON_interactors_libraries_encodings_text_read_file_with_license_header \
		"${AUTOMATON_DIRECTORY_ROOT}/entities/i18n/licenses/0bsd/en.txt" \
)
EOF
	unset ____output_prefix ____output_line

	## all good - output now
	printf -- "%s" "$____output"
	unset ____output


	# report status
	return 0
}




# report import status
return 0
