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




# make sure we are at the right location
if (-not (Test-Path -PathType Container -LiteralPath ".internals\automaton")) {
	$null = Write-Host @"
E: Are You in the Repository's Root Directory?
"@
	$global:LASTEXITCODE = 1
	return
}


${env:PROJECT_DIRECTORY_ROOT} = Get-Location
${env:PROJECT_DIRECTORY_INTERNAL} = "${env:PROJECT_DIRECTORY_ROOT}\.internals"
${env:PROJECT_DIRECTORY_BIN} = "${env:PROJECT_DIRECTORY_ROOT}\bin"
${env:PROJECT_DIRECTORY_DOC} = "${env:PROJECT_DIRECTORY_ROOT}\share\doc\chewkeanho\software\automaton"
${env:PROJECT_DIRECTORY_SRC} = "${env:PROJECT_DIRECTORY_ROOT}\src\chewkeanho\software\automaton"
${env:PROJECT_DIRECTORY_LIB} = "${env:PROJECT_DIRECTORY_ROOT}\lib\chewkeanho\software\automaton"
${env:PROJECT_DIRECTORY_TMP} = "${env:PROJECT_DIRECTORY_ROOT}\.local\tmp\automaton"
${env:PROJECT_DIRECTORY_PKG} = "${env:PROJECT_DIRECTORY_ROOT}\pkg"




# all good - begin mission
${env:PACKAGE_NAME} = "chewkeanho_automaton"
${env:GPG_ID} = "49B7878749107ED9C456267ACFD3316C29873FB5"
${env:VERSION} = .\.internals\automaton\Start.sh.ps1 version
${env:VERSION} = ${env:VERSION} -replace '\r?\n\z', ''




# checking dependencies
foreach ($____command in @("tar", "gpg", "git")) {
	$null = Write-Host @"
I: Checking '${____command}' Dependencies Now...
"@
	if (-not (Get-Command -Name $____command -ErrorAction SilentlyContinue)) {
		$null = Write-Host @"
E: '${____command}' = MISSING
E: Unable to Proceed.
E: Bailing Out...

"@
		$global:LASTEXITCODE = 1
		return
	} else {
		$null = Write-Host @"
I: '${____command}' = OK
"@
	}
}




# checking GPG key availability
$null = Write-Host @"
I: Checking GPG Signing Key...
"@
$____can_gpg = $true
$null = gpg --list-secret-keys ${env:GPG_ID} 2> $null
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
I: GPG Signing Is Not Possible.
"@
	$____can_gpg = $false
}




# remove existing output directories
foreach ($____item in @(
	${env:PROJECT_DIRECTORY_BIN},
	${env:PROJECT_DIRECTORY_DOC},
	${env:PROJECT_DIRECTORY_SRC},
	${env:PROJECT_DIRECTORY_LIB},
	${env:PROJECT_DIRECTORY_TMP},
	${env:PROJECT_DIRECTORY_PKG}
)) {
	$null = Write-Host @"
I: Purging '${____item}' now...
"@
	$null = Remove-Item `
		-Recurse `
		-Force `
		-LiteralPath $____item `
		-ErrorAction SilentlyContinue


	$null = Write-Host @"
I: Re-Creating '${____item}' now...
"@
	try {
		$null = New-Item `
			-ItemType Directory `
			-Force `
			-Path $____item `
			-ErrorAction Stop
	} catch {
		$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
		$global:LASTEXITCODE = 1
		return
	}
}




# package the source file now
foreach ($____item in $(
	@(
		(Join-Path ${env:PROJECT_DIRECTORY_INTERNAL} "automaton"),
		(Split-Path -Parent ${env:PROJECT_DIRECTORY_SRC})
	), @(
		(Join-Path ${env:PROJECT_DIRECTORY_INTERNAL} "automaton"),
		(Split-Path -Parent ${env:PROJECT_DIRECTORY_LIB})
	), @(
		(Join-Path ${env:PROJECT_DIRECTORY_INTERNAL} "automaton"),
		${env:PROJECT_DIRECTORY_TMP}
	), @(
		(Join-Path ${env:PROJECT_DIRECTORY_ROOT} ".github\workflows\git-push.yml"),
		(Join-Path ${env:PROJECT_DIRECTORY_TMP} "github-ci.yml")
	), @(
		(Join-Path ${env:PROJECT_DIRECTORY_ROOT} ".gitlab\ci.yml"),
		(Join-Path ${env:PROJECT_DIRECTORY_TMP} "gitlab-ci.yml")
	), @(
		(Join-Path ${env:PROJECT_DIRECTORY_INTERNAL} "automaton\entities\i18n\help"),
		${env:PROJECT_DIRECTORY_DOC}
	), @(
		(Join-Path ${env:PROJECT_DIRECTORY_INTERNAL} "automaton\Start.sh.ps1"),
		(Join-Path ${env:PROJECT_DIRECTORY_BIN} "chewkeanho-automaton")
	), @(
		(Join-Path ${env:PROJECT_DIRECTORY_INTERNAL} "automaton\Start.sh.ps1"),
		(Join-Path ${env:PROJECT_DIRECTORY_BIN} "chewkeanho-automaton.ps1")
	)
)) {
	## packing goodies
	try {
		$null = Write-Host @"
I: Packing '$($____item[0])' to '$($____item[1])'...
"@

		$null = Copy-Item -LiteralPath $____item[0] `
				-Destination $____item[1] `
				-Recurse `
				-Force `
				-ErrorAction Stop
	} catch {
		$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
		$global:LASTEXITCODE = 1
		return
	}
}




# organize payloads properly
$null = Write-Host @"
I: Re-Organizing '${env:PROJECT_DIRECTORY_TMP}\automaton'...
"@
try {
	$null = New-Item `
		-ItemType Directory `
		-Force `
		-Path "${env:PROJECT_DIRECTORY_TMP}\internals" `
		-ErrorAction Stop
} catch {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
	$global:LASTEXITCODE = 1
	return
}


try {
	$null = Move-Item -LiteralPath "${env:PROJECT_DIRECTORY_TMP}\automaton" `
		-Destination "${env:PROJECT_DIRECTORY_TMP}\internals\." `
		-Force `
		-ErrorAction Stop
} catch {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
	$global:LASTEXITCODE = 1
	return
}


try {
	$null = New-Item `
		-ItemType Directory `
		-Force `
		-Path "${env:PROJECT_DIRECTORY_TMP}\internals\ci" `
		-ErrorAction Stop
} catch {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
	$global:LASTEXITCODE = 1
	return
}


foreach ($____directory in (
	Get-ChildItem -Path "${env:PROJECT_DIRECTORY_INTERNAL}\ci\jobs"
)) {
	if (-not (Test-Path -PathType Container -LiteralPath $____directory)) {
		continue
	}

	$null = Write-Host @"
I: Creating CI Job Template '${____directory}'...
"@
	if (-not (Test-Path -PathType Leaf -LiteralPath "${____directory}\start.sh")) {
		$null = Write-Host @"
E: Missing 'start.sh'.
E: Skipping...
"@
		continue
	}

	if (-not (Test-Path -PathType Leaf -LiteralPath "${____directory}\start.ps1")) {
		$null = Write-Host @"
E: Missing 'start.ps1'.
E: Skipping...
"@
		continue
	}

	$____directory = Split-Path -Leaf -Path $____directory

	try {
		${env:AUTOMATON_DIRECTORY_JOBS} = "${env:PROJECT_DIRECTORY_TMP}\internals\ci"
		& "${env:PROJECT_DIRECTORY_INTERNAL}\automaton\Start.sh.ps1" `
			create $____directory
		if ($LASTEXITCODE -ne 0) {
			$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
			$global:LASTEXITCODE = 1
			return
		}
	} catch {
		$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
		$global:LASTEXITCODE = 1
		return
	}
}





# setup binary package
$null = Write-Host @"
I: Configuring '${env:PROJECT_DIRECTORY_BIN}'...
"@
## NOTE: Windows has no executable bit. Only apply when 'chmod' exists.
if (Get-Command -Name chmod -CommandType Application -ErrorAction SilentlyContinue) {
	foreach ($____item in @(
		Get-ChildItem -LiteralPath ${env:PROJECT_DIRECTORY_BIN} -Force
	)) {
		if ($____item.Name -clike '*.ps1') {
			chmod -x $____item.FullName
		} else {
			chmod +x $____item.FullName
		}
	}
}




# package the documentation now
foreach ($____item in @(
	"${env:PROJECT_DIRECTORY_ROOT}\AI_DECREES.md",
	"${env:PROJECT_DIRECTORY_ROOT}\CHANGELOG.md",
	"${env:PROJECT_DIRECTORY_ROOT}\CITATION.cff",
	"${env:PROJECT_DIRECTORY_ROOT}\CONTRIBUTORS.txt",
	"${env:PROJECT_DIRECTORY_ROOT}\CREATORS.txt",
	"${env:PROJECT_DIRECTORY_ROOT}\LICENSE.txt",
	"${env:PROJECT_DIRECTORY_ROOT}\README.md",
	"${env:PROJECT_DIRECTORY_ROOT}\REFERENCES.md",
	"${env:PROJECT_DIRECTORY_ROOT}\SECURITY.md"
)) {
	if (-not (Test-Path -PathType Leaf -LiteralPath $____item)) {
		$null = Write-Host @"
E: Missing Documentation Source: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"@
		$global:LASTEXITCODE = 1
		return
	}


	## filter all trademark banner off downstream
	$null = Write-Host @"
I: Packing '${____item}'...
"@
	foreach ($____line in Get-Content -Path $____item) {
		if ($____line.Contains(".internals/trademarks/banner_1200x100.svg")) {
			continue
		}

		$____filename = Split-Path -Leaf $____item
		$____filename_only = $____filename.Split('.')[0]
		$____file_extension = $____filename.Split('.')[1]
		$____item = $____item -replace "^$([regex]::Escape(${env:PROJECT_DIRECTORY_ROOT}))\\?", ""

		foreach ($____dest in @(
			"${env:PROJECT_DIRECTORY_TMP}\${____item}",
			"${env:PROJECT_DIRECTORY_DOC}\${____item}",
			"${env:PROJECT_DIRECTORY_PKG}\${____filename_only}_${env:VERSION}.${____file_extension}"
		)) {
			try {
				$null = Add-Content `
					-NoNewLine `
					-Path $____dest `
					-Value "${____line}`n"
			} catch {
				$null = Write-Host @"
E: Failed to Package: '${env:PROJECT_DIRECTORY_ROOT}\${____item}'
E: Unable to Proceed.
E: Bailing Out...

"@
				$global:LASTEXITCODE = 1
				return
			}
		}
	}
}




# archive now
$____pwd = Get-Location
$null = Set-Location ${env:PROJECT_DIRECTORY_TMP}
foreach ($____item in @(
	"${env:PACKAGE_NAME}_${env:VERSION}_linux_all.tar.xz",
	"${env:PACKAGE_NAME}_${env:VERSION}_linux_all.tar.gz",
	"${env:PACKAGE_NAME}_${env:VERSION}_freebsd_all.tar.xz",
	"${env:PACKAGE_NAME}_${env:VERSION}_freebsd_all.tar.gz",
	"${env:PACKAGE_NAME}_${env:VERSION}_windows_all.zip"
)) {
	$null = Write-Host @"
I: Archiving '${____item}'...
"@

	## equivalent of the shell's '*' glob (hidden nodes are excluded)
	$____pkg_entries = @(
		Get-ChildItem -LiteralPath ${env:PROJECT_DIRECTORY_TMP} -Name
	)

	switch -Wildcard -CaseSensitive ($____item) {
	"*.tar.xz" {
		tar -cvJf `
			(Join-Path ${env:PROJECT_DIRECTORY_PKG} $____item) `
			@____pkg_entries `
			| Out-Host
		if ($LASTEXITCODE -ne 0) {
			$null = Write-Host @"
E: Failed To Archive: '${env:PROJECT_DIRECTORY_PKG}\${____item}'
E: Unable to Proceed.
E: Bailing Out...

"@
			$global:LASTEXITCODE = 1
			return
		}
	} "*.tar.gz" {
		tar -cvzf `
			(Join-Path ${env:PROJECT_DIRECTORY_PKG} $____item) `
			@____pkg_entries `
			| Out-Host
		if ($LASTEXITCODE -ne 0) {
			$null = Write-Host @"
E: Failed To Archive: '${env:PROJECT_DIRECTORY_PKG}\${____item}'
E: Unable to Proceed.
E: Bailing Out...

"@
			$global:LASTEXITCODE = 1
			return
		}
	} "*.zip" {
		try {
			$null = Compress-Archive `
				-Force `
				-CompressionLevel Optimal `
				-Path .\* `
				-DestinationPath (Join-Path ${env:PROJECT_DIRECTORY_PKG} $____item)
		} catch {
			$null = Write-Host @"
E: Failed To Archive: '${env:PROJECT_DIRECTORY_PKG}\${____item}'
E: Unable to Proceed.
E: Bailing Out...

"@
			$global:LASTEXITCODE = 1
			return
		}
	}}
}
$null = Set-Location $____pwd




# cryptographically sign each payload
if ($____can_gpg -eq $true) {
	## signing artifacts
	foreach ($____item in (
		Get-ChildItem -LiteralPath ${env:PROJECT_DIRECTORY_PKG}
	)) {
		### gpg-sign artifact item
		$null = Write-Host @"
I: GPG-Signing '${____item}'...
"@
		$null = gpg --armor `
			--local-user ${env:GPG_ID} `
			--detach-sign $____item.FullName
		if ($LASTEXITCODE -ne 0) {
			$null = Write-Host @"
E: Execution Failed.
E: Failed To GPG Sign: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"@
			$global:LASTEXITCODE = 1
			return
		}
	}


	## export public key
	### !!! IMPORTANT !!!
	###	* DO NOT '--armor' it. Verify cannot work on armored keyring.
	$null = Write-Host @"
I: Exporting GPG Public Key to '${env:PROJECT_DIRECTORY_PKG}\public-key.gpg'...
"@
	gpg --output "${env:PROJECT_DIRECTORY_PKG}\public-key.gpg" `
		--export ${env:GPG_ID}
	if ($LASTEXITCODE -ne 0) {
		$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
		$global:LASTEXITCODE = 1
		return
	}
}




# clean up
$null = Write-Host @"
I: Cleaning Up...
"@




# report status
$null = Write-Host @"
S: Package Successful!
"@
$global:LASTEXITCODE = 0
return
