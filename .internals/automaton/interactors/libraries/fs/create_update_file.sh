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
#	`AUTOMATON_interactors_libraries_fs_create_update_file` is to write a
#	given data to a target path. It can encode data stream either as string
#	or as bytes list. The default is as string.
#
#	The write is transactional (atomic-write):
#		(1)	data is written to a temporary node
#			('[destination].tmp.<pid>') beside the destination path.
#		(2)	content is synchonized readily for use.
#		(3)	rename the temporary node into actual node for use.
#
#	For bytes list in a string, each line is a byte separated by a newline
#	('\n'). Each byte is complies to the following formats:
#		(1) hexadecimal
#			* Prefix: '0[xX]'
#			* Zero-Padding (e.g. '0x00FF'): supported
#			* Max-Length: not limited
#			* Accepts: 0x00 to 0xFF
#		(2) octal
#			* Prefix: '0'
#			* Zero-Padding (e.g. '00377'): supported
#			* Max-Length: 5 characters
#			* Accepts: 01-0377
#		(3) decimal (default)
#			* Prefix: None
#			* Zero-Padding: NOT supported
#			* Max-Length: 3 characters
#			* Accepts: 0-255
#
#	By default, this function throws an error if the input path is already
#	exist. Set the 'Allow Append' flag to allow append to file.
# Parameters:
#	(1) Input Path		REQUIRED.
#				The filepath to write. Note that the housing
#				directory **MUST** exist and the target file
#				**MUST** be missing.
#
#				Otherwise, error will be raised.
#	(2) Input Content	REQUIRED.
#				The input content for writing. It can be empty.
#	(3) Allow Append	OPTIONAL.
#				The flag for allowing append to existing
#				operation. Set 'true' to enable.
#
#				Default is disallowed.
#	(4) Byte Encoding	OPTIONAL.
#				The flag for encoding the read content as byte
#				data stream instead. Set 'true' to enable.
#
#				Default is string encoding.
# Outputs:
#	(1) Written File	The content is now written to the file.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given input path is empty.
#	'3'
#		*	means the given input path's target is invalid
#			(e.g. already exist).
#	'4'
#		*	means the given input path's housing directory is
#			missing.
#	'5'
#		*	means the given content is invalid (e.g. not bytes list
#			for byte encoder).
#	'6'
#		*	means the opreating system cannot execute this
#			operation.
#	'7'
#		*	means the given input path is invalid (e.g. not a node).
#	'1'
#		*	means bad execution.
AUTOMATON_interactors_libraries_fs_create_update_file() {
	#____input_path="$1"
	#____input_content="$2"
	#____allow_append="$3"
	#____byte_encoding="$4"


	# validate inputs
	if [ "${1:-}" = "" ]; then
		return 2
	fi

	if [ -b "${1:-}" ] ||
	[ -c "${1:-}" ] ||
	[ -p "${1:-}" ] ||
	[ -S "${1:-}" ] ||
	[ -L "${1:-}" ] ||
	[ -d "${1:-}" ]; then
		return 3
	fi

	if [ -f "${1:-}" ]; then
		case "${3:-}" in
		true|True|TRUE)
			# allow append
			;;
		*)
			return 3
			;;
		esac
	fi

	if [ ! "${1%/*}" = "${1:-}" ] &&
	[ ! "${1%/*}" = "" ] &&
	[ ! -d "${1%/*}" ]; then
		return 4
	fi

	case "${4:-}" in
	true|True|TRUE)
		# bytes encoding
		## scan list
		for ____runtime_data in ${2:-}; do
			case "$____runtime_data" in
			"+"|"-")
				# only single + sign
				unset ____runtime_data
				return 5
				;;
			0)
				;;
			-*)
				# negative value
				unset ____runtime_data
				return 5
				;;
			0[xX]?*)
				# seek hexadecimal:
				#	0x00-0xFF with zero-padding
				____runtime_data="${____runtime_data#??}"
				while [ ! "$____runtime_data" = "" ]; do
					case "${____runtime_data%%"${____runtime_data#?}"}" in
					0)
						____runtime_data="${____runtime_data#?}"
						continue
						;;
					[123456789aAbBcCdDeEfF])
						break
						;;
					*)
						unset ____runtime_data
						return 5
						;;
					esac
				done

				case "$____runtime_data" in
				""|\
				[123456789aAbBcCdDeEfF]|\
				[123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])
					;;
				*)
					unset ____runtime_data
					return 5
					;;
				esac
				;;
			0*)
				# seek octal:
				#	0000-0377 with zero-padding
				if [ "${#____runtime_data}" -gt 5 ]; then
					# octal spellings is max at '5'
					# ASCII characters. Anything longer is
					# invalid format.
					unset ____runtime_data
					return 5
				fi

				____runtime_data="${____runtime_data#?}"
				while [ ! "$____runtime_data" = "" ]; do
					case "${____runtime_data%%"${____runtime_data#?}"}" in
					0)
						____runtime_data="${____runtime_data#?}"
						continue
						;;
					[1234567])
						break
						;;
					*)
						unset ____runtime_data
						return 5
						;;
					esac
				done

				case "$____runtime_data" in
				""|\
				[1-7]|\
				[1-7][0-7]|\
				[1-3][0-7][0-7])
					;;
				*)
					unset ____runtime_data
					return 5
					;;
				esac
				;;
			[1-9]|\
			[1-9][0-9]|\
			1[0-9][0-9]|\
			2[0-4][0-9]|\
			25[0-5])
				# seek decimal:
				#	1-255
				;;
			*)
				# unacceptable value
				unset ____runtime_data
				return 5
				;;
			esac
		done
		unset ____runtime_data
		;;
	*)
		# string encoding
		;;
	esac

	AUTOMATON_interactors_libraries_os_is_command_available \
		"cp" \
		> /dev/null \
		2> /dev/null
	if [ $? -ne 0 ]; then
		return 6
	fi

	AUTOMATON_interactors_libraries_os_is_command_available \
		"mv" \
		> /dev/null \
		2> /dev/null
	if [ $? -ne 0 ]; then
		return 6
	fi

	AUTOMATON_interactors_libraries_os_is_command_available \
		"rm" \
		> /dev/null \
		2> /dev/null
	if [ $? -ne 0 ]; then
		return 6
	fi

	AUTOMATON_interactors_libraries_os_is_command_available \
		"sync" \
		> /dev/null \
		2> /dev/null
	if [ $? -ne 0 ]; then
		return 6
	fi


	# execute
	## clean up existing workspace file
	rm -rf -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
	sync -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null

	## perform copy when append is allowed and target is already exists
	if [ -e "${1:-}" ]; then
		case "${3:-}" in
		true|True|TRUE)
			# allow append
			cp -f -- "${1:-}" "${1:-}.tmp.$$" > /dev/null 2> /dev/null
			if [ $? -ne 0 ]; then
				rm -rf -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
				sync -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
				return 1
			fi
			;;
		*)
			;;
		esac
	fi

	## ensure the workspace node exists (powershell-specific)
	: >> "${1:-}.tmp.$$" 2> /dev/null
	if [ $? -ne 0 ]; then
		rm -rf -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
		sync -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
		return 1
	fi

	## perform write
	case "${4:-}" in
	true|True|TRUE)
		## write data bytes ('od'-compatible: whitespace-separated)
		for ____runtime_byte in ${2:-}; do
			printf \
				"\\$(printf '%03o' "$(( $____runtime_byte ))")" \
				>> "${1:-}.tmp.$$"
			if [ $? -ne 0 ]; then
				rm -rf -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
				sync -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
				unset ____runtime_byte
				return 1
			fi
		done
		unset ____runtime_byte
		;;
	*)
		## write data text (default)
		printf -- "%s" "${2:-}" >> "${1:-}.tmp.$$"
		if [ $? -ne 0 ]; then
			rm -rf -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
			sync -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
			return 1
		fi
		;;
	esac

	## ensure the content is ready before export
	sync -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null

	## successful write - perform overwrite
	mv -f -- "${1:-}.tmp.$$" "${1:-}" > /dev/null 2> /dev/null
	if [ $? -ne 0 ]; then
		rm -rf -- "${1:-}" > /dev/null 2> /dev/null
		sync -- "${1:-}" > /dev/null 2> /dev/null
		rm -rf -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
		sync -- "${1:-}.tmp.$$" > /dev/null 2> /dev/null
		return 1
	fi


	# report status
	return 0
}




# report import status
return 0
