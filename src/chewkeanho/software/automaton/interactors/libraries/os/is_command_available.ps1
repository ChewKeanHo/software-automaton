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
# `AUTOMATON_interactors_libraries_os_is_command_available` is to validate a
# given command is available from this current operating system.
#
# The output relies on the exit code both return as output and as exit code
# itself.
# Parameters:
#	(1) Input		REQUIRED.
#				The input command for validation.
# Outputs:
#	(1) Printed Exit Code	The exit code for embedded checking.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
#	'2'
#		* input is empty.
#	'3'
#		* input is invalid.
#	'1'
#		* bad execution.
function AUTOMATON_interactors_libraries_os_is_command_available {
	param (
		[string]$____input
	)


	# validate inputs
	if ([string]::IsNullOrEmpty($____input)) {
		$global:LASTEXITCODE = 2
		return 2
	}


	# execute
	if (Get-Command $____input -ErrorAction SilentlyContinue) {
		# exist
		$global:LASTEXITCODE = 0
		return 0
	}


	# report status
	$global:LASTEXITCODE = 3
	return 3
}




# report import status
$global:LASTEXITCODE = 0
return 0
