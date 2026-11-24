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
# `AUTOMATON_interactors_libraries_encodings_text_read_file_with_license_header`
# is to read a text file with trimmed license header instead of "as it is".
# Parameters:
#	(1) Filepath		REQUIRED.
#				The filepath to read the conf file.
#
# Outputs:
#	(1) Printed String	The file content with stripped license header.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
#	'2'
#		* missing filepath.
#	'3'
#		* invalid filepath.
#	'1'
#		* bad exec
function AUTOMATON_interactors_libraries_encodings_text_read_file_with_license_header {
	param (
		[string]$____filepath
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


	# execute
	$____interactors_parse_state = "license"
	$____interactors_parsed_value = ""
	foreach ($____line in Get-Content -Path $____filepath) {
		switch ($____line -replace '#.*$', '') {
		"" {
			switch ($____interactors_parse_state) {
			"content" {
				$____interactors_parsed_value = @"
${____interactors_parsed_value}${____line}

"@
			} default {
				# do nothing
			}}
		} default {
			$____interactors_parse_state = "content"
			$____interactors_parsed_value = @"
${____interactors_parsed_value}${____line}

"@
		}}
	}

	## output data
	Write-Output $____interactors_parsed_value


	# report status
	$global:LASTEXITCODE = 0
	return
}




# report import status
$global:LASTEXITCODE = 0
return
