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
#	`AUTOMATON_interactors_libraries_runtimes_load_modules` is to import a
#	given library module file or directory path into the current runtime for
#	extending functionalities in execution. This function will judiciously
#	reject the following cases:
#		(1) Incompatible file extension (e.g. 'Shell' seeks '.sh').
#		(2) Filename containing '_test[.ext]' test script suffix. The
#			'[.ext]' is optional so directory with '_test' suffix
#			is also affected.
#		(3) Filename containing '.' hidden file prefix.
#		(4) Filename containing '~' prefix, `.tmp` suffix, or '.temp'
#			suffix indicating a temporary file directory.
#
#	When the given path is a directory, this function can scan it both
#	recursively and non-recursively with safety level.
#
#	When $AUTOMATON_MODULES_TRACKER environment variable is defined, this
#	function will append the import path into the the designated tracker
#	file. Should the housing directory of the $AUTOMATON_MODULES_TRACKER is
#	missing, then error will be raised.
#
#	POWERSHELL-SPECIFIC SCOPING NOTICE:
#	Due to PowerShell's scoping feature, call this function from the top
#	level of your script using dot-source instead. Example:
#		. AUTOMATON_interactors_libraries_runtimes_load_modules ".\lib"
#	If the dot-source happens inside a function, everything lands in that
#	function's scope.
#
#	Important to maintainer: due to this scoping feature, this function
#	**MUST** maintain ZERO(0) variable leak at all cost.
# Parameters:
#	(1) Path			REQUIRED.
#					The path to import from. It can be a
#					file or directory.
#	(2) Recursive Depth		OPTIONAL.
#					The depth of recursive levels below the
#					given path. in base-10 number data type.
#
#					Set '0' to disable recursiveness or
#					'10' for 10-levels deep.
#
#					Default is '10'.
# Outputs:
#	(1) Imported Modules		The modules are imported.
# Exit Codes:
#	'0'
#		*	means ok.
#	'1'
#		*	means the given path is empty.
#	'2'
#		*	means the given path or the module itself is invalid.
#		*	means the given recursive depth is invalid (e.g. not a
#			valid whole number).
#	'3'
#		*	means there are errors in importing execution.
#	'4'	*	means the given $AUTOMATON_MODULES_TRACKER filepath is
#			facing some error (e.g. missing housing directory).
function AUTOMATON_interactors_libraries_runtimes_load_modules {
	param (
		[string]$____path,
		[string]$____recursive_depth
	)


	$global:____automaton_load_nest = [int]$global:____automaton_load_nest + 1
	try {
		# validate inputs
		if ([string]::IsNullOrEmpty($____path)) {
			$global:LASTEXITCODE = 1
			return
		}

		$____runtime_import_target = $____path
		$____runtime_node_info = Get-Item `
					-LiteralPath $____runtime_import_target `
					-Force `
					-ErrorAction SilentlyContinue
		if (
			($null -ne $____runtime_node_info) -and
			($____runtime_node_info.LinkType -in @('SymbolicLink', 'Junction'))
		) {
			## resolve symbolic link
			$____runtime_link = $null
			try {
				$____runtime_link = $____runtime_node_info.Target |
							Select-Object -First 1
			} catch {
			}
			if ([string]::IsNullOrEmpty($____runtime_link)) {
				$global:LASTEXITCODE = 2
				return
			}

			if (-not [System.IO.Path]::IsPathRooted($____runtime_link)) {
				$____runtime_link = Join-Path `
					([System.IO.Path]::GetDirectoryName($____runtime_node_info.FullName)) `
					$____runtime_link
			}

			$____runtime_import_target = [System.IO.Path]::GetFullPath($____runtime_link)
		}

		if (
			(-not ( Test-Path -LiteralPath $____runtime_import_target `
						-PathType Container `
			)) -and
			(-not (Test-Path -LiteralPath $____runtime_import_target `
						-PathType Leaf `
			))
		) {
			# not a file or directory
			$global:LASTEXITCODE = 2
			return
		}

		$____runtime_import_target = $____runtime_import_target -replace '[\\/]$', ''
		if (
			([string]::IsNullOrEmpty($____runtime_import_target)) -or
			($____runtime_import_target -match '^[A-Za-z]:$')
		) {
			# '/' or drive root input - refuse to scan the filesystem root
			$global:LASTEXITCODE = 2
			return
		}

		switch -Regex -CaseSensitive ($____recursive_depth) {
		'\A\z' {
			# unspecified - use default
			$____runtime_depth = [int64]10
		} '[^0-9]|\A0[0-9]' {
			# not a whole number
			$global:LASTEXITCODE = 2
			return
		} default {
			# whole number value
			try {
				$____runtime_depth = [int64]$____recursive_depth
			} catch {
				# overflow
				$global:LASTEXITCODE = 2
				return
			}
		}}

		if (-not [string]::IsNullOrEmpty($env:AUTOMATON_MODULES_TRACKER)) {
			$____test_path = $env:AUTOMATON_MODULES_TRACKER -replace '[\\/][^\\/]*\z', ''
			switch -CaseSensitive ($____test_path) {
			"" {
				## tracker at root
				## '/foo': housing is '/', which is always a directory.
				## Hence, we check for writability instead.
				if (-not (Test-Path `
					-LiteralPath $env:AUTOMATON_MODULES_TRACKER `
					-IsValid
				)) {
					$global:LASTEXITCODE = 4
					return
				}
			} $env:AUTOMATON_MODULES_TRACKER {
				## filename only
			} default {
				## check for missing directory
				if (-not (Test-Path `
						-PathType Container `
						-LiteralPath $____test_path
				)) {
					## missing housing directory
					$global:LASTEXITCODE = 4
					return
				}
			}}

			if (
				(Test-Path -LiteralPath $env:AUTOMATON_MODULES_TRACKER) -and
				(-not (Test-Path -PathType Leaf -LiteralPath $env:AUTOMATON_MODULES_TRACKER))
			) {
				## unknown tracker node
				$global:LASTEXITCODE = 4
				return
			}
		}


		# execute
		:loop foreach (
			$____runtime_import_item in @(
				Get-ChildItem `
					-LiteralPath $____runtime_import_target `
					-ErrorAction SilentlyContinue |
				Sort-Object -Property Name |
				ForEach-Object { $_.FullName }
			)
		) {
			if (-not (Test-Path -LiteralPath $____runtime_import_item)) {
				## broken node
				continue loop
			}

			## resolve symbolic link
			$____runtime_import_item_info = Get-Item `
				-Force `
				-LiteralPath $____runtime_import_item `
				-ErrorAction SilentlyContinue
			if (
				($null -ne $____runtime_import_item_info) -and
				($____runtime_import_item_info.LinkType -in @('SymbolicLink', 'Junction'))
			) {
				$____runtime_import_item_link = $null
				try {
					$____runtime_import_item_link = `
						$____runtime_import_item_info.Target `
							| Select-Object -First 1
				} catch {
				}
				if ([string]::IsNullOrEmpty($____runtime_import_item_link)) {
					continue loop
				}

				if (-not [System.IO.Path]::IsPathRooted($____runtime_import_item_link)) {
					$____runtime_import_item_link = Join-Path `
						([System.IO.Path]::GetDirectoryName( `
							$____runtime_import_item_info.FullName)) `
						$____runtime_import_item_link
				}
				$____runtime_import_item = `
					[System.IO.Path]::GetFullPath($____runtime_import_item_link)
			}

			## reject common patterns
			$____runtime_import_item_filename = Split-Path -Leaf $____runtime_import_item
			switch -Wildcard -CaseSensitive ($____runtime_import_item_filename) {
			".*" {
				## do not import hidden node
				continue loop
			} '*_test' {
				## do not import test node
				continue loop
			} '*_test.*' {
				## do not import test node
				continue loop
			} '~*' {
				## do not import temporary node
				continue loop
			} '*.tmp' {
				## do not import temporary node
				continue loop
			} '*.temp' {
				## do not import temporary node
				continue loop
			} default {
				## accepted
			}}

			## it is a directory
			if (
				Test-Path -PathType Container `
					-LiteralPath $____runtime_import_item
			) {
				if ($____runtime_depth -le 0) {
					## arrived at limited level
					continue loop
				}

				$null = . AUTOMATON_interactors_libraries_runtimes_load_modules `
						$____runtime_import_item `
						([string]($____runtime_depth - 1))
				$____runtime_depth = $____runtime_depth + 1
				switch ($global:LASTEXITCODE) {
				0 {
				} 4 {
					$global:LASTEXITCODE = 4
					return
				} default {
					$global:LASTEXITCODE = 3
					return
				}}

				continue loop
			} elseif (
				-not (
					Test-Path -PathType Leaf `
						-LiteralPath $____runtime_import_item
				)
			) {
				## not a file
				continue loop
			}

			## it is a file
			switch -Wildcard -CaseSensitive ($____runtime_import_item) {
			'*.ps1' {
				## accepted
			} default {
				## not a powershell script
				continue loop
			}}

			## all good - import now
			try {
				$global:LASTEXITCODE = 0
				$null = . $____runtime_import_item
			} catch {
				$global:LASTEXITCODE = 3
				return
			}
			if ($global:LASTEXITCODE -ne 0) {
				$global:LASTEXITCODE = 3
				return
			}

			## save tracker when enabled
			if (-not [string]::isNullOrEmpty(${env:AUTOMATON_MODULES_TRACKER})) {
				try {
					$null = Add-Content `
						-LiteralPath $env:AUTOMATON_MODULES_TRACKER `
						-Value "${____runtime_import_item}`n" `
						-NoNewline `
						-ErrorAction Stop
				} catch {
					$global:LASTEXITCODE = 4
					return
				}
			}
		}
	} finally {
		if (-not (Test-Path Variable:\global:____automaton_load_nest)) {
			$global:____automaton_load_nest = 0
		}

		$global:____automaton_load_nest = [int]$global:____automaton_load_nest - 1
		if ($global:____automaton_load_nest -le 0) {
			## outermost call: parent still needs its variables
			Remove-Variable -ErrorAction SilentlyContinue -Name `
				____runtime_*,
				____test_path,
				____recursive_depth,
				____path
			Remove-Variable -ErrorAction SilentlyContinue `
				-Scope Global `
				-Name ____automaton_load_nest
		}
	}


	# report status
	$global:LASTEXITCODE = 0
	return
}




# report import status
$global:LASTEXITCODE = 0
return
