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
function AUTOMATON_interactors_responses_licenses_render_license_notice {
	param (
		[string]$____comment_prefix
	)


	# execute
	## parse the data file
	$____output = ""
	foreach ($____line in (
		Get-Content -Path "${env:AUTOMATON_DIRECTORY_ROOT}\entities\i18n\licenses\0bsd\en.txt"
	)) {
		$____output_prefix = $____comment_prefix
		if ([string]::IsNullOrEmpty($____line)) {
			$____output_prefix = $____output_prefix -replace '\w*$', ''
		}

		$____output = "${____output}${____output_prefix}${____line}"
	}
	$null = Remove-Variable -Name ____output_prefix -ErrorAction SilentlyContinue
	$null = Remove-Variable -Name ____line -ErrorAction SilentlyContinue

	## all good - output now
	Write-Output $____output
	$null = Remove-Variable -Name ____output -ErrorAction SilentlyContinue


	# report status
	$global:LASTEXITCODE = 0
	return
}




# report import status
return 0
