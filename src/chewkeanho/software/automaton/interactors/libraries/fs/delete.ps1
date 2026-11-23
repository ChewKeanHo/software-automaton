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
# `AUTOMATON_interactors_libraries_fs_delete` is to delete a given filesystem
# node from this current operating system.
#
# This deletion is atomic by performing a move to a temporary node next to it
# prior to its actual deletion.
# Parameters:
#	(1) Input		REQUIRED.
#				The input path for deletion.
#	(2) Recursive Mode	OPTIONAL.
#				Flag to remove the node recursively (e.g. for
#				directory node). It accepts either 'true' or
#				'false'.
#
#				Default is 'false'.
# Outputs:
#	(1) Deleted Node	The node is deleted.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		*	ok.
#	'2'
#		*	means the given input is empty.
#	'3'
#		*	means the given input is invalid (e.g. not a file or
#			a directory).
#	'4'
#		*	means the given recursive mode is invalid (e.g. not a
#			boolean 'true' or 'false').
#	'5' (reserved)
#		*	means the os cannot cater this function (e.g. missing
#			dependency).
#	'1'
#		*	bad execution (e.g. non-recursive mode for a directory).
function AUTOMATON_interactors_libraries_fs_delete {
	param (
		[string]$____input,
		[bool]$____recursive_mode
	)


	# validate inputs
	if ([string]::IsNullOrEmpty($____input)) {
		$global:LASTEXITCODE = 2
		return
	}

	## normalize pathing. Example:
	##	'\path\dir\', '\path\dir\.' -> '\path\dir'
	$____runtime_input = $____input -replace '[\\/]\.?$', ''
	switch -CaseSensitive -Regex ($____runtime_input) {
	'^$' {
		## deleting the root directory itself is never a valid
		## operation.
		$null = Remove-Variable -Name ____runtime_input `
				-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 3
		return
	} '^[A-Za-z]:$' {
		## deleting the root directory itself is never a valid
		## operation.
		$null = Remove-Variable -Name ____runtime_input `
				-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 3
		return
	} '^\.$' {
		## do not service any precise relative path for safety
		## purposes.
		$null = Remove-Variable -Name ____runtime_input `
				-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 3
		return
	} '^\.\.$' {
		## do not service any precise relative path for safety
		## purposes.
		$null = Remove-Variable -Name ____runtime_input `
				-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 3
		return
	} '.*[\\/]\.\.$' {
		## do not service any precise relative path for safety
		## purposes.
		$null = Remove-Variable -Name ____runtime_input `
				-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 3
		return
	} default {
		break
	}}

	$____runtime_item = Get-Item -LiteralPath $____runtime_input `
				-Force `
				-ErrorAction SilentlyContinue
	if ($____runtime_item -eq $null) {
		## node is already gone - job is done and bail out
		$null = Remove-Variable -Name ____runtime_input `
				-ErrorAction SilentlyContinue
		$null = Remove-Variable -Name ____runtime_item `
				-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 0
		return
	} elseif ($____runtime_item.PSProvider.Name -ne 'FileSystem') {
		## reject non-deletable node (e.g. blocks/registry/certificate)
		$null = Remove-Variable -Name ____runtime_input `
				-ErrorAction SilentlyContinue
		$null = Remove-Variable -Name ____runtime_item `
				-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 3
		return
	} elseif (
		$____runtime_item.PSIsContainer -and
		($____runtime_item.Parent -eq $null)
	) {
		## refuse to delete a filesystem root (its 'Parent' is null)
		$null = Remove-Variable -Name ____runtime_input `
				-ErrorAction SilentlyContinue
		$null = Remove-Variable -Name ____runtime_item `
				-ErrorAction SilentlyContinue
		$global:LASTEXITCODE = 3
		return
	}

	$____runtime_is_link = (
		($____runtime_item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0
	)
	if ($____recursive_mode -ne $true) {
		# a directory requires explicit removal
		if (
			(-not $____runtime_is_link) -and
			$____runtime_item.PSIsContainer
		) {
			$null = Remove-Variable -Name ____runtime_input `
					-ErrorAction SilentlyContinue
			$null = Remove-Variable -Name ____runtime_item `
					-ErrorAction SilentlyContinue
			$null = Remove-Variable -Name ____runtime_is_link `
					-ErrorAction SilentlyContinue
			$global:LASTEXITCODE = 1
			return
		}
	}


	# execute
	## remove link if yes
	if ($____runtime_is_link) {
		try {
			if ($____runtime_item.PSIsContainer) {
				[System.IO.Directory]::Delete($____runtime_item.FullName, $false)
			} else {
				[System.IO.File]::Delete($____runtime_item.FullName)
			}

			$global:LASTEXITCODE = 0
		} catch {
			$global:LASTEXITCODE = 1
		}

		$null = Remove-Variable -Name ____runtime_input `
				-ErrorAction SilentlyContinue
		$null = Remove-Variable -Name ____runtime_item `
				-ErrorAction SilentlyContinue
		$null = Remove-Variable -Name ____runtime_is_link `
				-ErrorAction SilentlyContinue
		return
	}
	$null = Remove-Variable -Name ____runtime_is_link `
			-ErrorAction SilentlyContinue


	## move the node into a temporary one
	$____runtime_temp = "${____runtime_input}.to-delete.${pid}"
	try {
		Move-Item -LiteralPath $____runtime_input `
			-Destination $____runtime_temp `
			-Force `
			-ErrorAction Stop

		try {
			Remove-Item -LiteralPath $____runtime_temp `
				-Force `
				-Recurse:$____runtime_item.PSIsContainer `
				-ErrorAction Stop
		} catch {
			## handle error
			$null = Remove-Variable -Name ____runtime_input `
					-ErrorAction SilentlyContinue
			$null = Remove-Variable -Name ____runtime_temp `
					-ErrorAction SilentlyContinue
			$null = Remove-Variable -Name ____runtime_item `
					-ErrorAction SilentlyContinue
			$global:LASTEXITCODE = 1
			return
		}
	} catch {
		# target is still at its original location
		try {
			Remove-Item -LiteralPath $____runtime_input `
				-Force `
				-Recurse:$____runtime_item.PSIsContainer `
				-ErrorAction Stop
		} catch {
			## handle error
			$null = Remove-Variable -Name ____runtime_input `
					-ErrorAction SilentlyContinue
			$null = Remove-Variable -Name ____runtime_temp `
					-ErrorAction SilentlyContinue
			$null = Remove-Variable -Name ____runtime_item `
					-ErrorAction SilentlyContinue
			$global:LASTEXITCODE = 1
			return
		}
	}
	$null = Remove-Variable -Name ____runtime_input `
			-ErrorAction SilentlyContinue
	$null = Remove-Variable -Name ____runtime_temp `
			-ErrorAction SilentlyContinue
	$null = Remove-Variable -Name ____runtime_item `
			-ErrorAction SilentlyContinue


	# report status
	$global:LASTEXITCODE = 0
	return
}




# report import status
$global:LASTEXITCODE = 0
return
