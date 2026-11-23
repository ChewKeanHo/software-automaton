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
#	`AUTOMATON_interactors_responses_trademarks_get_header` is to get the
#	current header printout.
# Parameters:
#	(1) Version Number	REQUIRED.
#				The version number.
#	(2) License SPDX	REQUIRED.
#				The license SPDX tag.
# Outputs:
#	(1) Header String	The rendered header string.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means any of the given input is empty.
#	'1'
#		*	means bad execution.
function AUTOMATON_interactors_responses_trademarks_get_header {
	param (
		[string]$____version_number,
		[string]$____license_spdx
	)


	# validate input
	if ([string]::isNullorEmpty($____version_number)) {
		Write-Output ""
		$global:LASTEXITCODE = 2
		return
	}

	if ([string]::isNullorEmpty($____license_spdx)) {
		Write-Output ""
		$global:LASTEXITCODE = 2
		return
	}


	# execute
	Write-Output @"
$(
	AUTOMATON_interactors_libraries_encodings_text_read_file_with_license_header `
		"${env:AUTOMATON_DIRECTORY_ROOT}\entities\brand\trademark.txt"
)
${____version_number} | SPDX: ${____license_spdx}
"@


	# report status
	$global:LASTEXITCODE = 0
	return
}




# report import status
$global:LASTEXITCODE = 0
return
