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
# `AUTOMATON_interactors_libraries_fs_delete` is to delete a given filesystem
# node from this current operating system.
#
# This deletion is atomic by performing a move to a temporary node next to it
# prior to its actual deletion. An OS synchonization will run after the deletion
# for avoiding filesystem cache data corruption. Therefore, it requires 'rm',
# 'mv', and 'sync' to work properly.
# Parameters:
#	(1) Input		REQUIRED.
#				The input path for deletion.
#	(2) Recursive Mode	OPTIONAL.
#				Flag to remove the node recursively (e.g. for
#				directory node). It accepts either 'true' or
#				'false'.
#
#				Default is 'false'.
# Outputs:
#	(1) Deleted Node	The node is deleted.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		*	ok.
#	'2'
#		*	means the given input is empty.
#	'3'
#		*	means the given input is invalid (e.g. not a file or a
#			directory).
#	'4'
#		*	means the given recursive mode is invalid (e.g. not a
#			boolean 'true' or 'false').
#	'5'
#		*	means the os cannot cater this function (e.g. missing
#			dependency).
#	'1'
#		*	bad execution (e.g. non-recursive mode for a directory).
AUTOMATON_interactors_libraries_fs_delete() {
	#____runtime_input="$1"
	#____recursive_mode="$2"


	# validate inputs
	case "${1:-}" in
	"")
		return 2
		;;
	*)
		;;
	esac

	## normalize pathing. Example:
	##	'/path/dir/', '/path/dir/.' -> '/path/dir'
	____runtime_input="${1:-}"
	while [ ! "$____runtime_input" = "" ]; do
		case "$____runtime_input" in
		*/)
			____runtime_input="${____runtime_input%/}"
			;;
		*/.)
			____runtime_input="${____runtime_input%/.}"
			;;
		*)
			break
			;;
		esac
	done

	case "$____runtime_input" in
	"")
		## deleting the root directory itself is never a valid
		## operation.
		unset ____runtime_input
		return 3
		;;
	.|..|*/..)
		## do not service any precise relative path for safety purposes.
		unset ____runtime_input
		return 3
		;;
	*)
		;;
	esac

	if [ -b "$____runtime_input" ] || [ -c "$____runtime_input" ]; then
		## reject non-deletable node (e.g. blocks/characters)
		unset ____runtime_input
		return 3
	elif [ ! -e "$____runtime_input" ] && [ ! -L "$____runtime_input" ]; then
		## node is already gone - job is done and bail out
		unset ____runtime_input
		return 0
	fi

	case "${2:-}" in
	true|True|TRUE)
		;;
	""|false|False|FALSE)
		# a directory requires explicit removal
		if [ ! -L "$____runtime_input" ] && [ -d "$____runtime_input" ]; then
			unset ____runtime_input
			return 1
		fi
		;;
	*)
		unset ____runtime_input
		return 4
		;;
	esac

	for ____dependency in "rm" "sync" "mv"; do
		AUTOMATON_interactors_libraries_os_is_command_available \
			"$____dependency" \
			> /dev/null \
			2> /dev/null
		if [ $? -ne 0 ]; then
			unset ____dependency ____runtime_input
			return 5
		fi
	done
	unset ____dependency


	# execute
	## move the node into a temporary one
	____runtime_temp="${____runtime_input}.to-delete.$$"
	mv -f -- "$____runtime_input" "$____runtime_temp" > /dev/null 2> /dev/null
	if [ $? -eq 0 ]; then
		sync -- "${____runtime_input%/*}" > /dev/null 2> /dev/null
		case "${2:-}" in
		true|True|TRUE)
			rm -rf -- "$____runtime_temp" > /dev/null 2> /dev/null
			____runtime_process=$?
			;;
		*)
			rm -f -- "$____runtime_temp" > /dev/null 2> /dev/null
			____runtime_process=$?
			;;
		esac
	else
		# target is still at its original location
		case "${2:-}" in
		true|True|TRUE)
			rm -rf -- "$____runtime_input" > /dev/null 2> /dev/null
			____runtime_process=$?
			;;
		*)
			rm -f -- "$____runtime_input" > /dev/null 2> /dev/null
			____runtime_process=$?
			;;
		esac
	fi
	unset ____runtime_temp

	## perform cleaned sync
	if [ ! "${____runtime_input%/*}" = "${____runtime_input:-}" ]; then
		sync -- "${____runtime_input%/*}" > /dev/null 2> /dev/null
	else
		sync -- > /dev/null 2> /dev/null
	fi
	unset ____runtime_input

	## handle error
	if [ $____runtime_process -ne 0 ]; then
		unset ____runtime_process
		return 1
	fi
	unset ____runtime_process


	# report status
	return 0
}




# report import status
return 0
