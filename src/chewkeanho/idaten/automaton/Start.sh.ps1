echo \" <<'RUN_AS_BATCH' >/dev/null ">NUL "\" \`" <#"
@ECHO OFF
REM ----------------------------------------------------------------------------
REM Copyright 2026 The Automaton Project Team (https://github.com/ChewKeanHo/software-automaton)
REM
REM The above unified aliases have one or more actual legal entities listed
REM outside of this document: (1) 'CREATORS.txt' or 'AUTHORS.txt'; and
REM (2) 'CONTRIBUTORS.txt'. They are located usually placed next to this
REM document in their respective project repository. Please refer to them for
REM compiling the complete list accordingly.
REM
REM
REM Zero-Clause BSD
REM ===============
REM
REM Permission to use, copy, modify, and/or distribute this software for
REM any purpose with or without fee is hereby granted.
REM
REM THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL
REM WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
REM OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
REM FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
REM DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
REM AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
REM OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
REM ----------------------------------------------------------------------------




REM ############################################################################
REM # Windows BATCH Codes                                                      #
REM ############################################################################
SETLOCAL enabledelayedexpansion




REM configure
WHERE powershell >nul 2>&1
IF %ERRORLEVEL% neq 0 (
        ECHO E: PowerShell -> ???
        EXIT /b 1
)
SET "base_name=%~n0"
SET "source_file=%~f0"
SET "destination_file=%~dp0%base_name%.sh.ps1"




REM execute
IF exist "%destination_file%" GOTO :run_ps1
COPY /y "%source_file%" "%destination_file%" >nul
IF %ERRORLEVEL% neq 0 (
    ECHO E: Failed to create %destination_file%.
    EXIT /b 1
)


:run_ps1
powershell -NoProfile -ExecutionPolicy RemoteSigned -File "%destination_file%" %*
set "EXIT_CODE=!ERRORLEVEL!"

IF EXIST "%source_file%" (
        START /B "" cmd /c DEL "%source_file%" >nul 2>&1
)

EXIT /B %EXIT_CODE%
REM ############################################################################
REM # Windows BATCH Codes                                                      #
REM ############################################################################
EXIT /b 1
RUN_AS_BATCH
#> | Out-Null




echo \" <<'RUN_AS_POWERSHELL' >/dev/null # " | Out-Null
################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
# IMPORTANT NOTICE
# 1. Downstream ${____init_file} **MUST STRICTLY** 'return 0' (number 0) to
#    indicate a successful happy path. Anything else including missing is
#    failed.




# configure
${____init_file} = "init.ps1"
${____init_directory} ="lib\namespace"

${____init_package_name} = "My App"




# scan
# Current directory - user-customized application
${env:AUTOMATON_DIRECTORY} = "$(Get-Location)\.internals\automaton\presenters\${____init_file}"
if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native User Rootless Software Directory
        ${env:AUTOMATON_DIRECTORY} = "$(Get-Location)\automaton\presenters\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native User Rootless Software Directory
        ${env:AUTOMATON_DIRECTORY} = "$(Get-Location)\presenters\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native User Rootless Software Directory
        ${env:AUTOMATON_DIRECTORY} = "${env:LOCALAPPDATA}\Programs\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native User Chocolatey Software Directory
        ${env:AUTOMATON_DIRECTORY} = "${env:CHOCOLATEYINSTALL}\lib\${____init_package_name}\tools\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native User Scoop Custom Software Directory
        ${env:AUTOMATON_DIRECTORY} = "${env:SCOOP}\apps\${____init_package_name}\current\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native OS Chocolatey Software Directory
        ${env:AUTOMATON_DIRECTORY} = "${env:PROGRAMDATA}\chocolatey\lib\${____init_package_name}\tools\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native User Scoop Software Directory
        ${env:AUTOMATON_DIRECTORY} = "${env:USERPROFILE}\scoop\apps\${____init_package_name}\current\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native OS Scoop Software Directory
        ${env:AUTOMATON_DIRECTORY} = "${env:SCOOP_GLOBAL}\apps\${____init_package_name}\current\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native OS Program Files
        ${env:AUTOMATON_DIRECTORY} = "${env:PROGRAMFILES}\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        # Native OS Program Files (x86)
        ${env:AUTOMATON_DIRECTORY} = "${env:PROGRAMFILES(x86)}\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:AUTOMATON_DIRECTORY})) {
        Write-Error @"
E: Failed to Locate Init File. Bailing Out...

"@
        exit 1
}




# execute
$____process = . $env:AUTOMATON_DIRECTORY @args
if ($____process -eq "0") {
        exit 0
}
################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
exit 1
<#
RUN_AS_POWERSHELL




################################################################################
# Unix Main Codes                                                              #
################################################################################
# configure
____init_file="init.sh"
____init_directory="lib/namespace"

____init_package_name="My App"

____init_macos_bundle_name="${____init_package_name}.app"
____init_macos_directory="namespace"




# scan
# Native User Current Directory - User-Customized Application
AUTOMATON_DIRECTORY="${PWD%/}/.internals/automaton/presenters/${____init_file}"
if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        AUTOMATON_DIRECTORY="${PWD%/}/automaton/presenters/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        AUTOMATON_DIRECTORY="${PWD%/}/presenters/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        # Native User - Linux 2nd-Generation Package
        if ([ -d "/app" ] && [ -f "/.flatpak-info" ]); then
                # Flatpak
                AUTOMATON_DIRECTORY="/app/${____init_directory%/}/${____init_file}"
        elif [ ! "$APPDIR" = "" ]; then
                # AppImage
                AUTOMATON_DIRECTORY="${APPDIR%/}/${____init_directory%/}/${____init_file}"
        elif [ ! "$SNAP" = "" ]; then
                # Snapcraft
                AUTOMATON_DIRECTORY="${SNAP%/}/${____init_directory%/}/${____init_file}"
        fi
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        # Native User Rootless Local Directory
        AUTOMATON_DIRECTORY="${HOME%/}/.local/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        # Homebrew (Apple Silicon MacOS)
        AUTOMATON_DIRECTORY="/opt/homebrew/${____init_directory}/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        # Linuxbrew (Homebrew on Linux)
        AUTOMATON_DIRECTORY="/home/linuxbrew/.linuxbrew/${____init_directory}/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        # Native User Rootless OPT Directory
        AUTOMATON_DIRECTORY="/opt/${____init_package_name}/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ] &&
[ ! "${____init_macos_bundle_name%/}" = "" ] &&
[ ! "${____init_macos_directory%/}" = "" ]; then
        # MacOS User Rootless Local Application
        AUTOMATON_DIRECTORY="${HOME}/Applications/${____init_macos_bundle_name%/}/Contents/Resources/${____init_macos_directory%/}/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ] &&
[ ! "${____init_macos_bundle_name%/}" = "" ] &&
[ ! "${____init_macos_directory%/}" = "" ]; then
        # MacOS OS Application
        AUTOMATON_DIRECTORY="/Applications/${____init_macos_bundle_name%/}/Contents/Resources/${____init_macos_directory%/}/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        # Native OS Machine-Specific & Homebrew (Intel MacOS)
        AUTOMATON_DIRECTORY="/usr/local/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        # Native OS Distributor
        AUTOMATON_DIRECTORY="/usr/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        # Native OS Root
        AUTOMATON_DIRECTORY="/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$AUTOMATON_DIRECTORY" ]; then
        1>&2 printf "%s" "\
E: Failed to Locate Init File. Bailing Out...

"
        exit 1
fi




# execute
. "$AUTOMATON_DIRECTORY" "$@"
exit $?
################################################################################
# Unix Main Codes                                                              #
################################################################################
exit 1
#>
