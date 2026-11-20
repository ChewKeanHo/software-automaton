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




# execute
case "${2:-}" in
create)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/help/create/start.sh"
	return $?
	;;
license)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/help/license/start.sh"
	return $?
	;;
list)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/help/list/start.sh"
	return $?
	;;
run)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/help/run/start.sh"
	return $?
	;;
version)
	. "${AUTOMATON_DIRECTORY_ROOT}/presenters/help/version/start.sh"
	return $?
	;;
*)
	## trademark header
	AUTOMATON_interactors_libraries_os_print_info "\
$( \
	AUTOMATON_interactors_responses_trademarks_get_header \
		"$AUTOMATON_VERSION" \
		"$AUTOMATON_LICENSE" \
)
" "$AUTOMATON_COLOR_MODE"


	## content by language
	case "$AUTOMATON_LANG" in
	*)
		# default to 'en'
		AUTOMATON_interactors_libraries_os_print_info "\
$( \
	AUTOMATON_interactors_libraries_encodings_text_read_file_with_license_header \
		"${AUTOMATON_DIRECTORY_ROOT}/entities/i18n/help/en.txt" \
)

" "$AUTOMATON_COLOR_MODE"
		;;
	esac


	## list variables for self-check
	AUTOMATON_interactors_libraries_os_print_info "\
AUTOMATON_DIRECTORY_PWD:
${AUTOMATON_DIRECTORY_PWD}

AUTOMATON_DIRECTORY_PROJECT:
${AUTOMATON_DIRECTORY_PROJECT}

AUTOMATON_DIRECTORY_ROOT:
${AUTOMATON_DIRECTORY_ROOT}

AUTOMATON_COLOR_MODE:
${AUTOMATON_COLOR_MODE}

AUTOMATON_LANG:
${AUTOMATON_LANG}
" "$AUTOMATON_COLOR_MODE"
	;;
esac




# report status
return 0
