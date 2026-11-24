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
#	`AUTOMATON_interactors_libraries_runtimes_load_modules` is to import a
#	given library module file or directory path into the current runtime for
#	extending functionalities in execution. This function will judiciously
#	reject the following cases:
#		(1) Incompatible file extension (e.g. 'Shell' seeks '.sh').
#		(2) Filename containing '_test[.ext]' test script suffix. The
#			'[.ext]' is optional so directory with '_test' suffix
#			is also affected.
#		(3) Filename containing '.' hidden file prefix.
#		(4) Filename containing '~' prefix, `.tmp` suffix, or '.temp'
#			suffix indicating a temporary file directory.
#
#	When the given path is a directory, this function can scan it both
#	recursively and non-recursively with safety level.
#
#	When $AUTOMATON_MODULES_TRACKER environment variable is defined, this
#	function will append the import path into the the designated tracker
#	file. Should the housing directory of the $AUTOMATON_MODULES_TRACKER is
#	missing, then error will be raised.
# Parameters:
#	(1) Path			REQUIRED.
#					The path to import from. It can be a
#					file or directory.
#	(2) Recursive Depth		OPTIONAL.
#					The depth of recursive levels below the
#					given path. in base-10 number data type.
#
#					Set '0' to disable recursiveness or '10'
#					for 10-levels deep.
#
#					Default is '10'.
# Outputs:
#	(1) Imported Modules		The modules are implicitly imported.
#	(2) Error Module Path		The module filepath containing an error.
#					Empty when successful.
# Exit Codes:
#	'0'
#		*	means ok.
#	'1'
#		*	means the given path is empty.
#	'2'
#		*	means the given path or the module itself is invalid.
#		*	means the given recursive depth is invalid (e.g. not a
#			valid whole number).
#	'3'
#		*	means there are errors in importing execution.
#	'4'	*	means the given $AUTOMATON_MODULES_TRACKER filepath is
#			facing some error (e.g. missing housing directory).
AUTOMATON_interactors_libraries_runtimes_load_modules() {
	#____path="$1"
	#____recursive_depth="$2"


	# validate inputs
	if [ "${1:-}" = "" ]; then
		return 1
	fi

	____runtime_import_target="${1:-}"
	if [ -L "${1:-}" ]; then
		## resolve symbolic link
		____runtime_import_target="$( \
			readlink -f "${1:-}" 2> /dev/null \
		)" || {
			unset ____runtime_import_target
			return 2
		}
	fi

	if [ ! -d "$____runtime_import_target" ] &&
	[ ! -f "$____runtime_import_target" ]; then
		# not a file or directory
		unset ____runtime_import_target
		return 2
	fi

	____runtime_import_target="${____runtime_import_target%"/"}"
	if [ "$____runtime_import_target" = "" ]; then
		# '/' or drive root input - refuse to scan the filesystem root
		unset ____runtime_import_target
		return 2
	fi

	case "${2:-}" in
	"")
		# unspecified - use default
		;;
	*[!0-9]*|0[0-9]*)
		# not a whole number
		unset ____runtime_import_target
		return 2
		;;
	*)
		# whole number value
		;;
	esac

	if [ ! "${AUTOMATON_MODULES_TRACKER:-}" = "" ]; then
		case "${AUTOMATON_MODULES_TRACKER%/*}" in
		"")
			## tracker at root
			## '/foo': housing is '/', which is always a directory.
			## Hence, we check for writability instead.
			if [ ! -w "/" ]; then
				## no write permission anyway
				unset ____runtime_import_target
				return 4
			fi
			;;
		"${AUTOMATON_MODULES_TRACKER:-}")
			## filename only
			;;
		*)
			## check for missing directory
			if [ ! -d "${AUTOMATON_MODULES_TRACKER%/*}" ]; then
				## missing housing directory
				unset ____runtime_import_target
				return 4
			fi
			;;
		esac

		if [ -e "${AUTOMATON_MODULES_TRACKER:-}" ] &&
		[ ! -f "${AUTOMATON_MODULES_TRACKER:-}" ]; then
			## unknown tracker node
			unset ____runtime_import_target
			return 4
		fi
	fi


	# execute
	____runtime_scan_directory=true
	if [ -f "$____runtime_import_target" ]; then
		____runtime_scan_directory=false
	fi

	for ____runtime_import_item in "${____runtime_import_target}/"*; do
		if [ "$____runtime_scan_directory" = "false" ]; then
			## single-file mode: the glob above cannot match, so
			## strip the literal '/*' suffix to recover the path.
			____runtime_import_item="${____runtime_import_item%"/*"}"
		elif [ ! -e "$____runtime_import_item" ]; then
			## unmatched glob (empty directory) or broken node
			continue
		fi

		## resolve symbolic link
		if [ -L "$____runtime_import_item" ]; then
			____runtime_import_item="$( \
				readlink -f "$____runtime_import_item" \
					2> /dev/null \
			)" || continue
		fi

		## reject common patterns
		case "${____runtime_import_item##*/}" in
		"."*)
			## do not import hidden node
			continue
			;;
		*"_test"|*"_test."*)
			## do not import test node
			continue
			;;
		"~"*|*".tmp"|*".temp")
			## do not import temporary node
			continue
			;;
		*)
			## accepted
			;;
		esac

		## it is a directory
		if [ -d "$____runtime_import_item" ]; then
			if [ "${2:-10}" -le 0 ]; then
				## arrived at limited level
				continue
			fi

			AUTOMATON_interactors_libraries_runtimes_load_modules \
				"$____runtime_import_item" \
				"$(( ${2:-10} - 1 ))"
			case $? in
			0)
				# good - do nothing
				;;
			4)
				unset ____runtime_scan_directory \
					____runtime_import_item \
					____runtime_import_target
				return 4
				;;
			*)
				unset ____runtime_scan_directory \
					____runtime_import_item \
					____runtime_import_target
				return 3
				;;
			esac
			continue
		elif [ ! -f "$____runtime_import_item" ]; then
			## not a file
			continue
		fi

		## it is a file
		case "$____runtime_import_item" in
		*".sh")
			;;
		*)
			## not a shell script
			continue
			;;
		esac

		## all good - import now
		. "$____runtime_import_item"
		if [ $? -ne 0 ]; then
			printf -- "%s\n" "$____runtime_import_item"
			unset ____runtime_scan_directory \
				____runtime_import_item \
				____runtime_import_target
			return 3
		fi

		## save tracker when enabled
		if [ ! "${AUTOMATON_MODULES_TRACKER:-}" = "" ]; then
			printf -- \
				"%s\n" \
				"$____runtime_import_item" \
			>> "${AUTOMATON_MODULES_TRACKER:-}"
			if [ $? -ne 0 ]; then
				unset ____runtime_scan_directory \
					____runtime_import_item \
					____runtime_import_target
				return 4
			fi
		fi
	done
	unset ____runtime_scan_directory \
		____runtime_import_item \
		____runtime_import_target


	# report status
	return 0
}




# report import status
return 0
