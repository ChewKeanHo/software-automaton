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




# check $AUTOMATON_DIRECTORY_JOBS validity
if ([string]::IsNullOrEmpty(${env:AUTOMATON_DIRECTORY_JOBS})) {
	$null = AUTOMATON_interactors_libraries_os_print_error @"
`$AUTOMATON_DIRECTORY_JOBS => ???
"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}




# check [JOB] validity
if ([string]::IsNullOrEmpty($args[1])) {
	$null = AUTOMATON_interactors_libraries_os_print_error @"
[JOB] => ???
"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}




# test job path
$____job_path = "${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])\start.sh"
if (-not (Test-Path -PathType Leaf -LiteralPath $____job_path)) {
	$null = AUTOMATON_interactors_libraries_os_print_error @"
${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])\start.sh => ???
"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}


$____job_path = "${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])\start.ps1"
if (-not (Test-Path -PathType Leaf -LiteralPath $____job_path)) {
	$null = AUTOMATON_interactors_libraries_os_print_error @"
${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])\start.ps1 => ???
"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}




# execute job path
$global:LASTEXITCODE = 0
& $____job_path
if (
	($global:LASTEXITCODE -ne $null) -and
	($global:LASTEXITCODE -match '^[0-9]*$')
) {
	$global:LASTEXITCODE = $global:LASTEXITCODE
} elseif ($LASTEXITCODE) {
	$global:LASTEXITCODE = $LASTEXITCODE
}
return
