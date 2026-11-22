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
#	`AUTOMATON_interactors_libraries_os_read_lang` is to get the current
#	operating system's locale's language setting.
#
#	This function always return in '[ISO639-SET1/2]{-[ISO15924-CODE]}'
#	format. When the ISO15924-CODE is made available, the dash '-' prefix
#	is chosen instead of the underscore. The decision is mainly for
#	complying to the complete locale standardization format:
#		'[ISO639-SET1/2]{-[ISO15924-CODE]}{_[ISO3166-1-A2]}'
#
#	Since this function is always about the language code, the optional
#	'{_[ISO3166-1-A2]}' is always stripped.
# Parameters:
# Outputs:
#	(1) Language ID		The operating system's language ID in
#				'[ISO639-SET1/2]{-[ISO15924-CODE]}' format.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		* means ok.
AUTOMATON_interactors_libraries_os_read_lang() {
	# execute
	## source system language - fallback to UTF-8 English if none is
	## available.
	____runtime_lang="en.UTF-8"
	if [ ! "${LANG:-}" = "" ]; then
		____runtime_lang="${LANG:-}"
	elif [ ! "${LC_ALL:-}" = "" ]; then
		____runtime_lang="${LC_ALL:-}"
	elif [ ! "${LC_CTYPE:-}" = "" ]; then
		____runtime_lang="${LC_CTYPE:-}"
	elif [ ! "${LC_NUMERIC:-}" = "" ]; then
		____runtime_lang="${LC_NUMERIC:-}"
	elif [ ! "${LC_TIME:-}" = "" ]; then
		____runtime_lang="${LC_TIME:-}"
	elif [ ! "${LC_COLLATE:-}" = "" ]; then
		____runtime_lang="${LC_COLLATE:-}"
	elif [ ! "${LC_MONETARY:-}" = "" ]; then
		____runtime_lang="${LC_MONETARY:-}"
	elif [ ! "${LC_MESSAGES:-}" = "" ]; then
		____runtime_lang="${LC_MESSAGES:-}"
	elif [ ! "${LC_PAPER:-}" = "" ]; then
		____runtime_lang="${LC_PAPER:-}"
	elif [ ! "${LC_NAME:-}" = "" ]; then
		____runtime_lang="${LC_NAME:-}"
	elif [ ! "${LC_ADDRESS:-}" = "" ]; then
		____runtime_lang="${LC_ADDRESS:-}"
	elif [ ! "${LC_TELEPHONE:-}" = "" ]; then
		____runtime_lang="${LC_TELEPHONE:-}"
	elif [ ! "${LC_MEASUREMENT:-}" = "" ]; then
		____runtime_lang="${LC_MEASUREMENT:-}"
	elif [ ! "${LC_IDENTIFICATION:-}" = "" ]; then
		____runtime_lang="${LC_IDENTIFICATION:-}"
	fi

	## strip @modifier and .encoder if any
	____runtime_lang="${____runtime_lang%.*}"
	____runtime_lang="${____runtime_lang%%@*}"

	## strip trailing 'POSIX' variant (e.g. macOS 'en_US_POSIX')
	____runtime_lang="${____runtime_lang%_POSIX}"
	____runtime_lang="${____runtime_lang%-POSIX}"

	# process language by pattern - strip country
	case "$____runtime_lang" in
	[a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z]|\
	*_*_*)
		# e.g. 'zh_Hans_MY'
		____runtime_lang="${____runtime_lang%_*}"
		____runtime_lang="${____runtime_lang%_*}-${____runtime_lang#*_}"
		;;
	[a-zA-Z][a-zA-Z]-[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z]|\
	*-*_*)
		# e.g. 'zh-Hans_MY'
		____runtime_lang="${____runtime_lang%_*}"
		;;
	[a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z]|\
	*_[A-Z][A-Z])
		# e.g. 'zh_MY'
		____runtime_lang="${____runtime_lang%_*}"
		;;
	[a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]|\
	*_*)
		# e.g. 'zh_Hans'
		____runtime_lang="${____runtime_lang%_*}-${____runtime_lang#*_}"
		;;
	[a-zA-Z][a-zA-Z]-[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]-[a-zA-Z][a-zA-Z]|\
	*-*-*)
		# e.g. 'zh-Hans-MY'
		____runtime_lang="${____runtime_lang%-*}"
		;;
	[a-zA-Z][a-zA-Z]-[a-zA-Z][a-zA-Z]|\
	*-[A-Z][A-Z])
		# e.g. 'zh-MY'
		____runtime_lang="${____runtime_lang%-*}"
		;;
	*-*)
		# e.g. 'zh-Hans'
		;;
	C|POSIX)
		# e.g. 'C', 'POSIX'
		____runtime_lang="en"
		;;
	"")
		# e.g. ''
		____runtime_lang="en"
		;;
	*)
		# e.g. 'zh'
		;;
	esac

	printf -- "%s"  "$____runtime_lang"
	unset ____runtime_lang


	# report status
	return 0
}




# report import status
return 0
