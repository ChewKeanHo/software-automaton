#requires -Version 5.1
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
function AUTOMATON_interactors_libraries_fs_create_update_file {
	param (
		[string]$____input_path,
		[string]$____input_content,
		[bool]$____allow_append,
		[bool]$____byte_encoding
	)


	# validate inputs
	if ([string]::IsNullOrEmpty($____input_path)) {
		$global:LASTEXITCODE = 2
		return
	}

	if (Test-Path -PathType Container -LiteralPath $____input_path) {
		$global:LASTEXITCODE = 3
		return
	}

	if (
		(Test-Path -PathType Leaf -LiteralPath $____input_path) -and
		($____allow_append -ne $true)
	) {
		# disallowed to append
		$global:LASTEXITCODE = 3
		return
	}

	if ($____input_path -cmatch '^(.+)[/\\]') {
		if (-not (Test-Path -PathType Container -LiteralPath $Matches[1])) {
			$global:LASTEXITCODE = 4
			return
		}
	}

	if ($____byte_encoding -eq $true) {
		# bytes encoding
		## scan list
		foreach ($____runtime_data in @(
			$____input_content -split '\s+' `
				| Where-Object { $_ -ne '' }
		)) {
			switch -CaseSensitive -Regex ($____runtime_data) {
			"^[+-]$" {
				# only single +/- sign
				$null = Remove-Variable -Name ____runtime_data `
					-ErrorAction SilentlyContinue
				$global:LASTEXITCODE = 5
				return
			} "^0$" {
				break
			} "^-.*$" {
				# negative value
				$null = Remove-Variable -Name ____runtime_data `
					-ErrorAction SilentlyContinue
				$global:LASTEXITCODE = 5
				return
			} "^0[xX]0*[0123456789aAbBcCdDeEfF]{1,2}$" {
				# seek hexadecimal:
				#	up to 0xFF with zero-padded spellings included
				break
			} "^0{1,2}[0123]?[01234567]{0,2}$" {
				# seek octal:
				#	up to 0377 with zero-padded spellings included
				break
			} "^([1-9][0-9]?|1[0-9]{2}|2[0-4][0-9]|25[0-5])$" {
				# seek decimal: 1-255
				break
			} default {
				# unacceptable value
				$null = Remove-Variable -Name ____runtime_data `
					-ErrorAction SilentlyContinue
				$global:LASTEXITCODE = 5
				return
			}}
		}

		$null = Remove-Variable -Name ____runtime_data `
			-ErrorAction SilentlyContinue
	} else {
		# string encoding
	}


	# execute
	## clean up existing workspace file
	$null = Remove-Item -Force -Recurse `
		-LiteralPath "${____input_path}.tmp.${pid}" `
		-ErrorAction SilentlyContinue

	## perform copy when append is allowed and target is already exists
	if (
		(Test-Path -LiteralPath $____input_path) -and
		($____allow_append -eq $true)
	) {
		# allow append
		try {
			Copy-Item -LiteralPath $____input_path `
				-Destination "${____input_path}.tmp.${pid}" `
				-Force `
				-ErrorAction Stop
		} catch {
			$null = Remove-Item -Force -Recurse `
				-LiteralPath "${____input_path}.tmp.${pid}" `
				-ErrorAction SilentlyContinue
			$global:LASTEXITCODE = 1
			return
		}
	}

	## ensure the workspace node exists (powershell-specific)
	try {
		if (-not (Test-Path -LiteralPath "${____input_path}.tmp.${pid}")) {
			$null = New-Item -ItemType File `
					-Path "${____input_path}.tmp.${pid}" `
					-ErrorAction Stop
		}
	} catch {
		$null = Remove-Item -Force -Recurse `
			-LiteralPath "${____input_path}.tmp.${pid}" `
			-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 1
		return
	}


	## perform write
	if ($____byte_encoding -eq $true) {
		foreach ($____runtime_byte in @(
			$____input_content -split '\s+' `
				| Where-Object { $_ -ne '' }
		)) {
			try {
				$____runtime_base = 10
				if ($____runtime_byte -cmatch '^0[xX]') {
					$____runtime_base = 16
				} elseif ($____runtime_byte -cmatch '^0') {
					$____runtime_base = 8
				}

				$____runtime_byte = [Convert]::ToByte($____runtime_byte, $____runtime_base)

				$null = Add-Content -LiteralPath "${____input_path}.tmp.${pid}" `
						-Value $____runtime_byte `
						-AsByteStream `
						-ErrorAction Stop
			} catch {
				$null = Remove-Item -Force -Recurse `
					-LiteralPath "${____input_path}.tmp.${pid}" `
					-ErrorAction SilentlyContinue
				$null = Remove-Variable -Name ____runtime_base `
						-ErrorAction SilentlyContinue
				$null = Remove-Variable -Name ____runtime_byte `
						-ErrorAction SilentlyContinue
				$global:LASTEXITCODE = 1
				return
			}
		}
		$null = Remove-Variable -Name ____runtime_base `
			-ErrorAction SilentlyContinue
		$null = Remove-Variable -Name ____runtime_byte `
			-ErrorAction SilentlyContinue
	} else {
		## write data text (default)
		try {
			Add-Content -NoNewLine `
				-LiteralPath "${____input_path}.tmp.${pid}" `
				-Value $____input_content `
				-Encoding utf8 `
				-ErrorAction Stop
		} catch {
			$null = Remove-Item -Force -Recurse `
				-LiteralPath "${____input_path}.tmp.${pid}" `
				-ErrorAction SilentlyContinue
			$global:LASTEXITCODE = 1
			return
		}
	}

	## ensure the content is ready before export
	## NOTE: On Windows, this is not required.

	## successful write - perform overwrite
	try {
		Move-Item -Destination $____input_path `
			-LiteralPath "${____input_path}.tmp.${pid}" `
			-Force `
			-ErrorAction Stop
	} catch {
		$null = Remove-Item -Force -Recurse `
			-LiteralPath $____input_path `
			-ErrorAction SilentlyContinue
		$null = Remove-Item -Force -Recurse `
			-LiteralPath "${____input_path}.tmp.${pid}" `
			-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 1
		return
	}


	# report status
	$global:LASTEXITCODE = 0
	return
}




# report import status
$global:LASTEXITCODE = 0
return
