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
#	`AUTOMATON_interactors_libraries_fs_create_directory` is to create a
#	given directory path.
# Parameters:
#	(1) Input			REQUIRED.
#					The full directory path to create.
# Outputs:
#	(1) Created Directory		The directory is created.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		* means ok.
#	'2'
#		* means the given input is empty.
#	'3'
#		* means the given input is not a directory when exist.
#	'4'
#		* means the operating system cannot execute this operation.
#	'1'
#		* means error in execution.
function AUTOMATON_interactors_libraries_fs_create_directory {
	param (
		[string]$____input
	)


	# validate inputs
	if ([string]::IsNullOrEmpty($____input)) {
		$global:LASTEXITCODE = 2
		return
	}

	if (Test-Path -PathType Leaf -LiteralPath $____input) {
		$global:LASTEXITCODE = 3
		return
	}

	if (Test-Path -PathType Container -LiteralPath $____input) {
		$global:LASTEXITCODE = 0
		return
	}


	# execute
	try {
		$null = New-Item `
			-ItemType Directory `
			-Path $____input `
			-ErrorAction Stop
	} catch {
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
