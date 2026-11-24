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
# `AUTOMATON_interactors_libraries_os_read_terminal_color_mode` is to get the
# current terminal console's color mode in bit size.
# Parameters:
# Outputs:
#	(1) Color Depth (number)	The color bits of the current terminal.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
function AUTOMATON_interactors_libraries_os_read_terminal_color_mode {
	# execute
	## try parse from $COLORTERM environment variable.
	if (${env:COLORTERM} -in 'truecolor', '24bit', '24-bit') {
		$global:LASTEXITCODE = 0
		return '24'
	}

	## try prse from WT_SESSION environment variable.
	if (-not [string]::IsNullOrEmpty(${env:WT_SESSION})) {
		$global:LASTEXITCODE = 0
		return '24'
	}

	## try parse from VS code integrated terminal.
	if (${env:ConEmuANSI} -eq "ON") {
		$global:LASTEXITCODE = 0
		return '24'
	}

	## try prase from ANSI shim for legacy console.
	if (-not [string]::IsNullOrEmpty(${env:ANSICON})) {
		$global:LASTEXITCODE = 0
		return '4'
	}

	## try parse from $TERM environment variable.
	switch -Regex (${env:TERM}) {
	'24bit|truecolor|direct' {
		$global:LASTEXITCODE = 0
		return '24'
	} '256color' {
		$global:LASTEXITCODE = 0
		return '8'
	} 'dumb' {
		$global:LASTEXITCODE = 0
		return '1'
	} default {
		$global:LASTEXITCODE = 0
		return '1'
	}}
}




# report import status
$global:LASTEXITCODE = 0
return
