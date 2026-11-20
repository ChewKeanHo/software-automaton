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




# execute
switch -CaseSensitive ($args[1]) {
"create" {
	$null = . "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\help\create\start.ps1" @args
	$global:LASTEXITCODE = 0
	return
"license" {
	$null = . "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\help\license\start.ps1" @args
	$global:LASTEXITCODE = 0
	return
} "list" {
	$null = . "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\help\list\start.ps1" @args
	$global:LASTEXITCODE = 0
	return
} "run" {
	$null = . "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\help\run\start.ps1" @args
	$global:LASTEXITCODE = 0
	return
} "version" {
	$null = . "${env:AUTOMATON_DIRECTORY_ROOT}\presenters\help\version\start.ps1" @args
	$global:LASTEXITCODE = 0
	return
} default {
	## trademark header
	$null = AUTOMATON_interactors_libraries_os_print_info @"
$(
	AUTOMATON_interactors_responses_trademarks_get_header `
		${env:AUTOMATON_VERSION} `
		${env:AUTOMATON_LICENSE}
)
"@ ${env:AUTOMATON_COLOR_MODE}


	## content by language
	switch -CaseSensitive (${env:AUTOMATON_LANG}) {
	default {
		# default to 'en'
		$null = AUTOMATON_interactors_libraries_os_print_info @"
$(
	AUTOMATON_interactors_libraries_encodings_text_read_file_with_license_header `
		"${env:AUTOMATON_DIRECTORY_ROOT}\entities\i18n\help\en.txt"
)

"@ ${env:AUTOMATON_COLOR_MODE}
	}}


	## list variables for self-check
	$null = AUTOMATON_interactors_libraries_os_print_info @"
AUTOMATON_DIRECTORY_PWD:
${env:AUTOMATON_DIRECTORY_PWD}

AUTOMATON_DIRECTORY_PROJECT:
${env:AUTOMATON_DIRECTORY_PROJECT}

AUTOMATON_DIRECTORY_ROOT:
${env:AUTOMATON_DIRECTORY_ROOT}

AUTOMATON_COLOR_MODE:
${env:AUTOMATON_COLOR_MODE}

AUTOMATON_LANG:
${env:AUTOMATON_LANG}
"@ ${env:AUTOMATON_COLOR_MODE}
}}




# report status
$global:LASTEXITCODE = 0
return 0
