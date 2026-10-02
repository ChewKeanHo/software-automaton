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




# import libraries
function AUTOMATON_Print_Error {
	param (
		[string]$____content,
		[string]$____color
	)

	## !!! IMPORTANT NOTICE !!!
	## The variable names here are intentionally misspelled for avoiding
	## unwanted naming collision.


	# validate inputs
	$_____runtime_x_retnirp_color = $false
	switch -Regex ($____color) {
	'^$' {
		break
	} '[^0-9]' {
		break
	} default {
		if ([int]$____color -ge 8) {
			$_____runtime_x_retnirp_color = $true
		}
	}}


	# execute
	foreach (
		$_____runtime_x_retnirp_line in `
			$($____content -replace '\n$', '' -split '\r?\n')
	) {
		if ($_____runtime_x_retnirp_color -eq $true) {
			$null = Write-Host -ForegroundColor red @"
E: ${_____runtime_x_retnirp_line}
"@
		} else {
			$null = Write-Host @"
E: ${_____runtime_x_retnirp_line}
"@
		}
	}


	# report status
	return 0
}


function AUTOMATON_Print_Info {
	param (
		[string]$____content,
		[string]$____color
	)


	## !!! IMPORTANT NOTICE !!!
	## The variable names here are intentionally misspelled for avoiding
	## unwanted naming collision.


	# validate inputs
	$_____runtime_x_retnirp_color = $false
	switch -Regex ($____color) {
	'^$' {
		break
	} '[^0-9]' {
		break
	} default {
		if ([int]$____color -ge 8) {
			$_____runtime_x_retnirp_color = $true
		}
	}}


	# execute
	foreach (
		$_____runtime_x_retnirp_line in `
			$($____content -replace '\n$', '' -split '\r?\n')
	) {
		if ($_____runtime_x_retnirp_color -eq $true) {
			$null = Write-Host -ForegroundColor cyan @"
I: ${_____runtime_x_retnirp_line}
"@
		} else {
			$null = Write-Host @"
I: ${_____runtime_x_retnirp_line}
"@
		}
	}


	# report status
	return 0
}


function AUTOMATON_Read_Terminal_Color_Mode {
	# execute
	## try parse from $COLORTERM environment variable.
	if (${env:COLORTERM} -in 'truecolor', '24bit', '24-bit') {
		return '24'
	}

	## try prse from WT_SESSION environment variable.
	if (-not [string]::IsNullOrEmpty(${env:WT_SESSION})) {
		return '24'
	}

	## try parse from VS code integrated terminal.
	if (${env:ConEmuANSI} -eq "ON") {
		return '24'
	}

	## try prase from ANSI shim for legacy console.
	if (-not [string]::IsNullOrEmpty(${env:ANSICON})) {
		return '4'
	}

	## try parse from $TERM environment variable.
	switch -Regex (${env:TERM}) {
	'24bit|truecolor|direct' {
		return '24'
	} '256color' {
		return '8'
	} 'dumb' {
		return '1'
	} default {
		return '1'
	}}


	# report status
	return 0
}




# configure console colors
${env:AUTOMATON_COLOR_MODE} = AUTOMATON_Read_Terminal_Color_Mode




# locate AUTOMATON_DIRECTORY.
# This is already set by the scanner Start.sh.ps1 script. Hence, no additional
# work is required.
#
# If it is unset, this means the script is operating using invalid method to
# initialize so it **MUST** be failed at all time.
if ([string]::IsNullOrEmpty(${env:AUTOMATON_DIRECTORY})) {
	$null = AUTOMATON_Print_Error  @"
'`$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
} elseif (-not (${env:AUTOMATON_DIRECTORY} -match "init\.ps1$")) {
	$null = AUTOMATON_Print_Error  @"
'`$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
} elseif (-not (Test-Path -PathType Leaf -LiteralPath ${env:AUTOMATON_DIRECTORY})) {
	$null = AUTOMATON_Print_Error  @"
'`$AUTOMATON_DIRECTORY' -> ?!?!  <- Dev!!!

"@ ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}




# save AUTOMATON_DIRECTORY_PWD current directory
${env:AUTOMATON_DIRECTORY_PWD} = (Get-Location).Path




# locate AUTOMATON_DIRECTORY_PROJECT directory
${env:AUTOMATON_DIRECTORY_PROJECT} = (Get-Location).Path
while ($true) {
	if (
		${env:AUTOMATON_DIRECTORY_PROJECT} -eq `
			[System.IO.Path]::GetPathRoot(${env:AUTOMATON_DIRECTORY_PROJECT})
	) {
		$null = AUTOMATON_Print_Error  @"
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




# locate the localized AUTOMATON_DIRECTORY_ROOT App directory
if (
	Test-Path -PathType Leaf `
		-LiteralPath "${env:AUTOMATON_DIRECTORY_PROJECT}\.internals\automaton\app\presenters\init.ps1" `
) {
	${env:AUTOMATON_DIRECTORY_ROOT} = "${env:AUTOMATON_DIRECTORY_PROJECT}\.internals\automaton\app"
} else {
	${env:AUTOMATON_DIRECTORY_ROOT} = ${env:AUTOMATON_DIRECTORY} -replace 'init\.ps1$'
	${env:AUTOMATON_DIRECTORY_ROOT} = ${env:AUTOMATON_DIRECTORY_ROOT} -replace '\\$'
	${env:AUTOMATON_DIRECTORY_ROOT} = ${env:AUTOMATON_DIRECTORY_ROOT} -replace 'presenters$'
	${env:AUTOMATON_DIRECTORY_ROOT} = ${env:AUTOMATON_DIRECTORY_ROOT} -replace '\\$'
}




# define all directory names
if (-not [string]::IsNullOrEmpty(${env:AUTOMATON_DIRECTORY_JOBS})) {
	${env:AUTOMATON_DIRECTORY_JOBS} = ${env:AUTOMATON_DIRECTORY_JOBS} -replace '\\$'
} else {
	${env:AUTOMATON_DIRECTORY_JOBS} = "${env:AUTOMATON_DIRECTORY_PROJECT}\.internals\ci\jobs"
}


## setup relative ____job_location for error and help printout
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




# execute by first parameter
switch -CaseSensitive ("$($args[0])") {
'run' {
	if (
		(${env:AUTOMATON_DIRECTORY_JOBS} -ne "") -and
		("$($args[1])" -ne "")
	) {
		$____job_path = "${env:AUTOMATON_DIRECTORY_JOBS}\$($args[1])\start.ps1"
		if (Test-Path -PathType Leaf -LiteralPath $____job_path) {
			$global:LASTEXITCODE = 0
			& $____job_path
			$global:LASTEXITCODE = $LASTEXITCODE
			return
		}

		$null = AUTOMATON_Print_Error @"
'$($args[1])' = '${____job_location}\$($args[1])\start.ps1' => ???




"@ ${env:AUTOMATON_COLOR_MODE}
	}
} { $_ -in "-h", "help", "Help", "HELP" } {
} default {
		$null = AUTOMATON_Print_Error @"
'$($args[0])' => ???




"@ ${env:AUTOMATON_COLOR_MODE}
}}




# print help
$____jobs = ""
if (${env:AUTOMATON_DIRECTORY_JOBS} -ne "") {
	if (
		Test-Path -PathType Container `
			-LiteralPath ${env:AUTOMATON_DIRECTORY_JOBS}
	) {
		foreach ($____item in (
			Get-ChildItem -ErrorAction SilentlyContinue `
				-LiteralPath ${env:AUTOMATON_DIRECTORY_JOBS} |
			Where-Object { $_.Name -notlike '.*' }
		)) {
			if (-not $____item.PSIsContainer) {
				continue
			}

			if (
				Test-Path -PathType Leaf `
					-LiteralPath (Join-Path $____item.FullName 'start.ps1')
			) {
				$____jobs = "${____jobs}`t* $($____item.Name)`n"
			}
		}
	}
}

if ($____jobs -eq "") {
	$____jobs = "----"
}

$____message = @"
(Holloway) Chew, Kean Ho's
_______ _     _ _______  _____  _______ _______ _______  _____  __   __
|_____| |     |    |    |     | |  |  | |_____|    |    |     | | \\  |
|     | |_____|    |    |_____| |  |  | |     |    |    |_____| |  \\_|
_________________________________________________________________________
v0.0.1
0bsd

$ [COMMAND] run [JOB] -> ${____job_location}/[JOB]/start.{sh,ps1}
$ [COMMAND] help
_________________________________________________________________________

[JOBS]:
${____jobs}


AUTOMATON_DIRECTORY_PWD:
${env:AUTOMATON_DIRECTORY_PWD}

AUTOMATON_DIRECTORY_PROJECT:
${env:AUTOMATON_DIRECTORY_PROJECT}

AUTOMATON_DIRECTORY_ROOT:
${env:AUTOMATON_DIRECTORY_ROOT}

AUTOMATON_COLOR_MODE:
${env:AUTOMATON_COLOR_MODE}
"@
switch -CaseSensitive ("$($args[0])") {
{ $_ -in "-h", "help", "Help", "HELP" } {
	$null = AUTOMATON_Print_Info $____message ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 0
	return
} default {
	$null = AUTOMATON_Print_Error $____message ${env:AUTOMATON_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}}
