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
if ((${env:AUTOMATON_DIRECTORY_JOBS} -ne "") -and ("$($args[1])" -ne "")) {
	$____job_path = "${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])\start.ps1"
	if (Test-Path -PathType Leaf -LiteralPath $____job_path) {
		$global:LASTEXITCODE = 0
		& $____job_path
		$global:LASTEXITCODE = $LASTEXITCODE
		return
	}
}




# default action
$____job_location = ${env:AUTOMATON_DIRECTORY_JOBS}
if (
	$____job_location.StartsWith(
		${env:AUTOMATON_DIRECTORY_PWD}, [StringComparison]::Ordinal
	)
) {
	$____job_location = $____job_location.Substring(
		${env:AUTOMATON_DIRECTORY_PWD}.Length
	)

	if ($____job_location.StartsWith('\')) {
		$____job_location = $____job_location.Substring(1)
	}

	$____job_location = ".\${____job_location}"
}


$null = AUTOMATON_Print_Error @"
'$($args[1])' = '${____job_location}\$($args[1])\start.ps1' => ???
"@ ${env:AUTOMATON_COLOR_MODE}
$global:LASTEXITCODE = 1
return
