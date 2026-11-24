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




# locate AUTOMATON_DIRECTORY.
# This is already set by the scanner Start.sh.ps1 script. Hence, no additional
# work is required.
#
# If it is unset, this means the script is operating using invalid method to
# initialize so it **MUST** be failed at all time.
if ([string]::IsNullOrEmpty(${env:AUTOMATON_DIRECTORY})) {
	$null = Write-Host @"
E: '`$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
} elseif (-not (${env:AUTOMATON_DIRECTORY} -match "init\.ps1$")) {
	$null = Write-Host @"
'`$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
} elseif (-not (Test-Path -PathType Leaf -LiteralPath ${env:AUTOMATON_DIRECTORY})) {
	$null = Write-Host @"
'`$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
}




# locate the AUTOMATON_DIRECTORY_ROOT App directory
${env:AUTOMATON_DIRECTORY_ROOT} = ${env:AUTOMATON_DIRECTORY} -replace 'init\.ps1$'
${env:AUTOMATON_DIRECTORY_ROOT} = ${env:AUTOMATON_DIRECTORY_ROOT} -replace '\\$'
${env:AUTOMATON_DIRECTORY_ROOT} = ${env:AUTOMATON_DIRECTORY_ROOT} -replace 'presenters$'
${env:AUTOMATON_DIRECTORY_ROOT} = ${env:AUTOMATON_DIRECTORY_ROOT} -replace '\\$'




# import libraries
if (-not (Test-Path -PathType Leaf `
	-LiteralPath "${env:AUTOMATON_DIRECTORY_ROOT}\interactors\libraries\runtimes\load_modules.ps1" `
)) {
	$null = Write-Host @"
E: 'runtimes\load_modules' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
}


$null = . "${env:AUTOMATON_DIRECTORY_ROOT}\interactors\libraries\runtimes\load_modules.ps1"
if (-not (Get-Command AUTOMATON_interactors_libraries_runtimes_load_modules `
		 -errorAction SilentlyContinue `
)) {
	$null = Write-Host @"
E: 'AUTOMATON_interactors_libraries_runtimes_load_modules' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
}

$null = . AUTOMATON_interactors_libraries_runtimes_load_modules `
	"${env:AUTOMATON_DIRECTORY_ROOT}\entities"
$null = . AUTOMATON_interactors_libraries_runtimes_load_modules `
	"${env:AUTOMATON_DIRECTORY_ROOT}\views"
$null = . AUTOMATON_interactors_libraries_runtimes_load_modules `
	"${env:AUTOMATON_DIRECTORY_ROOT}\interactors"




# configure console colors
${env:AUTOMATON_COLOR_MODE} = AUTOMATON_interactors_libraries_os_read_terminal_color_mode




# configure app metadata
${env:AUTOMATON_VERSION} = AUTOMATON_interactors_responses_trademarks_get_version
${env:AUTOMATON_LICENSE} = AUTOMATON_interactors_responses_trademarks_get_license
${env:AUTOMATON_LANG} = AUTOMATON_interactors_libraries_os_read_lang




# save AUTOMATON_DIRECTORY_PWD current directory
${env:AUTOMATON_DIRECTORY_PWD} = (Get-Location).Path




# locate AUTOMATON_DIRECTORY_PROJECT directory
${env:AUTOMATON_DIRECTORY_PROJECT} = (Get-Location).Path
while ($true) {
	if (
		${env:AUTOMATON_DIRECTORY_PROJECT} -eq `
			[System.IO.Path]::GetPathRoot(${env:AUTOMATON_DIRECTORY_PROJECT})
	) {
		$null = AUTOMATON_interactors_libraries_os_print_error  @"
'`$AUTOMATON_DIRECTORY_PROJECT' -> ?!?!  <- Dev!!!

"@ ${env:AUTOMATON_COLOR_MODE}
		$global:LASTEXITCODE = 1
		return
	} elseif (
		Test-Path -PathType Container `
			-LiteralPath "${env:AUTOMATON_DIRECTORY_PROJECT}\.git" `
	) {
		break
	}

	${env:AUTOMATON_DIRECTORY_PROJECT} = `
		Split-Path -Parent ${env:AUTOMATON_DIRECTORY_PROJECT}
}




# locate AUTOMATON_DIRECTORY_JOBS directory
if (-not [string]::IsNullOrEmpty(${env:AUTOMATON_DIRECTORY_JOBS})) {
	${env:AUTOMATON_DIRECTORY_JOBS} = ${env:AUTOMATON_DIRECTORY_JOBS} -replace '\\$'
} else {
	${env:AUTOMATON_DIRECTORY_JOBS} = "${env:AUTOMATON_DIRECTORY_PROJECT}\.internals\ci\jobs"
}




# execute by first parameter
switch -CaseSensitive ($args[0]) {
"create" {
	. "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\create\start.ps1" @args
	return
} "delete" {
	. "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\delete\start.ps1" @args
	return
} { $_ -in "-h", "help", "Help", "HELP" } {
	. "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\help\start.ps1" @args
	return
} "license" {
	. "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\license\start.ps1" @args
	return
} "list" {
	. "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\list\start.ps1" @args
	return
} "run" {
	. "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\run\start.ps1" @args
	return
} "version" {
	. "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\version\start.ps1" @args
	return
} default {
	$null = AUTOMATON_interactors_libraries_os_print_error @"
'$($args[0])' => ???
"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}}
