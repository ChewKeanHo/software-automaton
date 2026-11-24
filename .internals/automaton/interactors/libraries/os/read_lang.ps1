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
#	`AUTOMATON_interactors_libraries_os_read_lang` is to get the current
#	operating system's locale's language setting.
#
#	This function always return in '[ISO639-SET1/2]{-[ISO15924-CODE]}'
#	format. When the ISO15924-CODE is made available, the dash '-' prefix
#	is chosen instead of the underscore. The decision is mainly for
#	complying to the complete locale standardization format:
#		'[ISO639-SET1/2]{-[ISO15924-CODE]}{_[ISO3166-1-A2]}'
#
#	Since this function is always about the language code, the optional
#	'{_[ISO3166-1-A2]}' is always stripped.
# Parameters:
# Outputs:
#	(1) Language ID		The operating system's language ID in
#				'[ISO639-SET1/2]{-[ISO15924-CODE]}' format.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		* means ok.
function AUTOMATON_interactors_libraries_os_read_lang {
	param()


	# execute
	## source system language - fallback to UTF-8 English if none is
	## available.
	$____runtime_lang = "en.UTF-8"
	if (-not [string]::IsNullOrEmpty(${env:LANG})) {
		$____runtime_lang = ${env:LANG}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_ALL})) {
		$____runtime_lang = ${env:LC_ALL}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_CTYPE})) {
		$____runtime_lang = ${env:LC_CTYPE}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_NUMERIC})) {
		$____runtime_lang = ${env:LC_NUMERIC}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_TIME})) {
		$____runtime_lang = ${env:LC_TIME}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_COLLATE})) {
		$____runtime_lang = ${env:LC_COLLATE}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_MONETARY})) {
		$____runtime_lang = ${env:LC_MONETARY}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_MESSAGES})) {
		$____runtime_lang = ${env:LC_MESSAGES}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_PAPER})) {
		$____runtime_lang = ${env:LC_PAPER}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_NAME})) {
		$____runtime_lang = ${env:LC_NAME}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_ADDRESS})) {
		$____runtime_lang = ${env:LC_ADDRESS}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_TELEPHONE})) {
		$____runtime_lang = ${env:LC_TELEPHONE}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_MEASUREMENT})) {
		$____runtime_lang = ${env:LC_MEASUREMENT}
	} elseif (-not [string]::IsNullOrEmpty(${env:LC_IDENTIFICATION})) {
		$____runtime_lang = ${env:LC_IDENTIFICATION}
	} elseif (Get-Command -Name Get-UICulture -ErrorAction SilentlyContinue) {
		## Windows fallback #1 - the OS UI language (BCP-47 tag, e.g.
		## 'en-US', 'zh-Hans').
		$____runtime_lang = (Get-UICulture).Name
		if ([string]::IsNullOrEmpty($____runtime_lang)) {
			$____runtime_lang = "en.UTF-8"
		}
	} elseif (Get-Command -Name Get-Culture -ErrorAction SilentlyContinue) {
		## Windows fallback #2 - the regional format culture.
		$____runtime_lang = (Get-Culture).Name
		if ([string]::IsNullOrEmpty($____runtime_lang)) {
			$____runtime_lang = "en.UTF-8"
		}
	}

	## strip @modifier and encoder if any
	$____runtime_lang = $____runtime_lang -creplace '\.[^.]*$', ''
	$____runtime_lang = $____runtime_lang -creplace '@.*$', ''

	## strip trailing 'POSIX' variant (e.g. macOS 'en_US_POSIX')
	$____runtime_lang = $____runtime_lang -creplace '[_-]POSIX$', ''

	# process language by pattern - strip country
	switch -Regex -CaseSensitive ($____runtime_lang) {
	"^[a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z]$" {
		# e.g. 'zh_Hans_MY'
		$____runtime_lang = $____runtime_lang -creplace '_[^_]*$', ''
		$____runtime_lang = $____runtime_lang -creplace '_', '-'
		break
	} "^.*_.*_.*$" {
		# e.g. 'zh_Hans_MY'
		$____runtime_lang = $____runtime_lang -creplace '_[^_]*$', ''
		$____runtime_lang = $____runtime_lang -creplace '_', '-'
		break
	} "^[a-zA-Z][a-zA-Z]-[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z]$" {
		# e.g. 'zh-Hans_MY'
		$____runtime_lang = $____runtime_lang -creplace '_[^_]*$', ''
		break
	} "^.*-.*_.*$" {
		# e.g. 'zh-Hans_MY'
		$____runtime_lang = $____runtime_lang -creplace '_[^_]*$', ''
		break
	} "^[a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z]$" {
		# e.g. 'zh_MY'
		$____runtime_lang = $____runtime_lang -creplace '_[^_]*$', ''
		break
	} "^.*_[A-Z][A-Z]$" {
		# e.g. 'zh_MY'
		$____runtime_lang = $____runtime_lang -creplace '_[^_]*$', ''
		break
	} "^[a-zA-Z][a-zA-Z]_[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]$" {
		# e.g. 'zh_Hans'
		$____runtime_lang = $____runtime_lang -creplace '_', '-'
		break
	} "^.*_.*$" {
		# e.g. 'zh_Hans'
		$____runtime_lang = $____runtime_lang -creplace '_', '-'
		break
	} "^[a-zA-Z][a-zA-Z]-[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]-[a-zA-Z][a-zA-Z]$" {
		# e.g. 'zh-Hans-MY'
		$____runtime_lang = $____runtime_lang -creplace '-[^-]*$', ''
		break
	} "^.*-.*-.*$" {
		# e.g. 'zh-Hans-MY'
		$____runtime_lang = $____runtime_lang -creplace '-[^-]*$', ''
		break
	} "^[a-zA-Z][a-zA-Z]-[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]$" {
		# e.g. 'zh-Hans'
		break
	} "^[a-zA-Z][a-zA-Z]-[a-zA-Z][a-zA-Z]$" {
		# e.g. 'zh-MY'
		$____runtime_lang = $____runtime_lang -creplace '-[^-]*$', ''
		break
	} "^.*-[A-Z][A-Z]$" {
		# e.g. 'zh-MY'
		$____runtime_lang = $____runtime_lang -creplace '-[^-]*$', ''
		break
	} "^.*-.*$" {
		# e.g. 'zh-Hans'
		break
	} "^C$" {
		# 'C'
		$____runtime_lang="en"
		break
	} "^POSIX$" {
		# 'POSIX'
		$____runtime_lang="en"
		break
	} "^$" {
		# ''
		$____runtime_lang="en"
		break
	} default {
		# e.g. 'zh'
		break
	}}


	# report status
	$global:LASTEXITCODE = 0
	return $____runtime_lang
}




# report import status
$global:LASTEXITCODE = 0
return
