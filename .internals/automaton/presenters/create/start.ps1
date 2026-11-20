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




# check $AUTOMATON_DIRECTORY_JOBS validity
if ([string]::IsNullOrEmpty(${env:AUTOMATON_DIRECTORY_JOB})) {
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




# check existing directory
if (Test-Path -LiteralPath "${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])") {
	$null = AUTOMATON_interactors_libraries_os_print_error @"
${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1]) => ???
"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}




## create directory node
$null = AUTOMATON_interactors_libraries_fs_create_directory `
	"${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])"
if ($global:LASTEXITCODE -ne 0) {
	$null = AUTOMATON_interactors_libraries_os_print_error @"
${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1]) => !!!
"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}




## create start.sh
$null = AUTOMATON_interactors_libraries_fs_create_update_file `
	"${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])\start.sh" `
	@"
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
$(AUTOMATON_interactors_responses_licenses_render_license_notice "# ")




# print demo
1>&2 printf -- "%s\n" "Hello World, from '$($args[1])'."




# report status
return 0
"@ `
	$false `
	$false
if ($global:LASTEXITCODE -ne 0) {
	AUTOMATON_interactors_libraries_os_print_error "\
'${env:AUTOMATON_DIRECTORY_JOBS}/${2:-}' => !!!
" ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}




## create start.ps1
$null = AUTOMATON_interactors_libraries_fs_create_update_file `
	"${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])\start.ps1" `
	@"
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
$(AUTOMATON_interactors_responses_licenses_render_license_notice "# ")




# print demo
$null = Write-Host "Hello World, from '$(args[1])'."




# report status
return 0
"@ `
	$false `
	$false
if ($global:LASTEXITCODE -ne 0) {
	AUTOMATON_interactors_libraries_os_print_error "\
'${env:AUTOMATON_DIRECTORY_JOBS}/${2:-}' => !!!
" ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}




# report status
$global:LASTEXITCODE = 0
return
