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




# check XuanQi's health and status
$null = Write-Host @"
I: Checking Automaton's Usability...
"@
if (-not (Test-Path -Path ".\.internals\automaton\Start.sh.ps1" -PathType Leaf)) {
	$null = Write-Host @"
E: Execution Failed (file).
E: Are You At Repository's Root Directory?
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's Help API...
"@
.\.internals\automaton\Start.sh.ps1 help
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's Create Help API...
"@
.\.internals\automaton\Start.sh.ps1 help create
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's Delete Help API...
"@
.\.internals\automaton\Start.sh.ps1 help delete
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's License Help API...
"@
.\.internals\automaton\Start.sh.ps1 help license
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's List Help API...
"@
.\.internals\automaton\Start.sh.ps1 help list
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's run Help API...
"@
.\.internals\automaton\Start.sh.ps1 help run
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's Version Help API...
"@
.\.internals\automaton\Start.sh.ps1 help version
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's Version API...
"@
$_version = .\.internals\automaton\Start.sh.ps1 version
$null = Write-Host @"
I: Got '${_version}'
"@
if ([string]::IsNullOrEmpty($_version)) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}
$null = Remove-Variable -ErrorAction SilentlyContinue -Name _version




$null = Write-Host @"
I: Testing Automaton's License API...
"@
$_license = .\.internals\automaton\Start.sh.ps1 license
$null = Write-Host @"
I: Got '${_license}'
"@
if ([string]::IsNullOrEmpty($_license)) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$global:LASTEXITCODE = 1
	return
}
$null = Remove-Variable -ErrorAction SilentlyContinue -Name _license




$null = Write-Host @"
I: Testing Automaton's Create API...
"@
$_name = "Wanda"
.\.internals\automaton\Start.sh.ps1 create $_name
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$null = Remove-Variable -ErrorAction SilentlyContinue -Name _name
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's List API...
"@
$_list = .\.internals\automaton\Start.sh.ps1 list
$null = Write-Host @"
I: Got '${_list}'
"@
switch -WildCard -CaseSensitive ($_list) {
"*${_name}*" {
} default {
	$null = Write-Host @"
E: Execution Failed (Missing '${_name}').
E: Unable to Proceed.
E: Bailing Out...
"@
	$null = Remove-Variable -ErrorAction SilentlyContinue -Name _list
	$null = Remove-Variable -ErrorAction SilentlyContinue -Name _name
	$global:LASTEXITCODE = 1
	return
}}
$null = Remove-Variable -ErrorAction SilentlyContinue -Name _list




$null = Write-Host @"
I: Testing Automaton's Delete API...
"@
$_name = "Wanda"
.\.internals\automaton\Start.sh.ps1 delete $_name
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$null = Remove-Variable -ErrorAction SilentlyContinue -Name _name
	$global:LASTEXITCODE = 1
	return
}




$null = Write-Host @"
I: Testing Automaton's List API...
"@
$_list = .\.internals\automaton\Start.sh.ps1 list
$null = Write-Host @"
I: Got '${_list}'
"@
switch -WildCard -CaseSensitive ($_list) {
"*${_name}*" {
	$null = Write-Host @"
E: Execution Failed ('${_name}' Still Exists).
E: Unable to Proceed.
E: Bailing Out...
"@
	$null = Remove-Variable -ErrorAction SilentlyContinue -Name _list
	$null = Remove-Variable -ErrorAction SilentlyContinue -Name _name
	$global:LASTEXITCODE = 1
	return
} default {
}}
$null = Remove-Variable -ErrorAction SilentlyContinue -Name _list
$null = Remove-Variable -ErrorAction SilentlyContinue -Name _name




# report status
$global:LASTEXITCODE = 0
return
