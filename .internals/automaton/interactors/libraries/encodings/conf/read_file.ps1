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
# 'AUTOMATON_interactors_libraries_encodings_conf_read_file' is to read a
# configuration file for its value.
# Parameters:
#	(1) Filepath				REQUIRED.
#						The filepath to read the .conf
#						file.
#	(2) Name				REQUIRED.
#						The variable name from the
#						confgiuration file.
# Outputs:
#	(1) Environment Variable Set		The environment variable is set
#						to the value of the file against
#						the given name as its name.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
#	'2'
#		* missing filepath.
#	'3'
#		* invalid filepath.
#	'4'
#		* missing name.
#	'5'
#		* invalid name.
#	'6'
#		* mismatched variable name.
#	'1'
#		* bad exec
function AUTOMATON_interactors_libraries_encodings_conf_read_file {
	param (
		[string]$____filepath,
		[string]$____name
	)


	# validate inputs
	if ([string]::IsNullOrEmpty($____filepath)) {
		$global:LASTEXITCODE = 2
		return
	}

	if (-not (Test-Path -PathType Leaf -LiteralPath $____filepath)) {
		$global:LASTEXITCODE = 3
		return
	}

	switch -Wildcard -CaseSensitive ($____name) {
	"" {
		$global:LASTEXITCODE = 4
		return
	} "*[a-z]*" {
		$global:LASTEXITCODE = 5
		return
	} "[0-9]*" {
		$global:LASTEXITCODE = 5
		return
	} { $_ -cnotmatch '^[A-Z_]+$' } {
		$global:LASTEXITCODE = 5
		return
	} default {
		# do nothing
	}}


	# execute
	$____interactors_parse_state = "opener"
	$____interactors_parsed_value = ""
	:loop foreach($____line in (Get-Content -LiteralPath $____filepath)) {
		$____stripped = $____line
		$____index = $____line.IndexOf('#')
		if ($____index -ge 0) {
			$____stripped = $____line.Substring(0, $____index)
		}

		switch -Wildcard -CaseSensitive ($____stripped) {
		"" {
			# do nothing
		} '* = """' {
			switch -CaseSensitive ($____interactors_parse_state) {
			"opener" {
				$____interactors_parse_state = "content"
			} default {
				$global:LASTEXITCODE = 1
				return
			}}

			$____key = $____line.Substring(
				0,
				$____stripped.IndexOf(' = ', [StringComparison]::Ordinal)
			)
			switch -CaseSensitive ($____key) {
			$____name {
				# do nothing
			} default {
				$global:LASTEXITCODE = 6
				return
			}}
		} '"""' {
			switch -CaseSensitive ($____interactors_parse_state) {
			"content" {
				$____interactors_parse_state = "end"
				break loop
			} default {
				$global:LASTEXITCODE = 1
				return
			}}
		} default {
			switch -CaseSensitive ($____interactors_parse_state) {
			"content" {
				$____interactors_parsed_value =
					"${____interactors_parsed_value}${____line}`n"
			} default {
				# do nothing
			}}
		}}
	}


	# report status
	switch -CaseSensitive ($____interactors_parse_state) {
	"end" {
		if ($____interactors_parsed_value.EndsWith("`n")) {
			$____interactors_parsed_value =
				$____interactors_parsed_value.Substring(
					0,
					$____interactors_parsed_value.Length - 1
				)
		}

		[Environment]::SetEnvironmentVariable(
			$____name,
			$____interactors_parsed_value,
			'Process'
		)
		$global:LASTEXITCODE = 0
		return
	} default {
		[Environment]::SetEnvironmentVariable(
			$____name,
			$null,
			'Process'
		)
		$global:LASTEXITCODE = 1
		return
	}}
}




# report import status
$global:LASTEXITCODE = 0
return
