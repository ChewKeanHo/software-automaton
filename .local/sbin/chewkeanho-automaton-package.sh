#!/bin/sh
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
if [ ! -d ".internals/automaton" ]; then
	1>&2 printf -- "%s" "\
E: Are You in the Repository's Root Directory?
"
	exit 1
fi
PROJECT_DIRECTORY_ROOT="$PWD"
PROJECT_DIRECTORY_INTERNAL="${PROJECT_DIRECTORY_ROOT}/.internals"
PROJECT_DIRECTORY_SHARE="${PROJECT_DIRECTORY_ROOT}/share/doc/chewkeanho/idaten"
PROJECT_DIRECTORY_SRC="${PROJECT_DIRECTORY_ROOT}/src/chewkeanho/idaten"
PROJECT_DIRECTORY_PKG="${PROJECT_DIRECTORY_ROOT}/pkg"




# all good - begin mission
VERSION="$(${PROJECT_DIRECTORY_ROOT}/.internals/automaton/Start.sh.ps1 version)"
VERSION="${VERSION%"
"}"
printf -- "%s" "\
_______ _     _ _______  _____  _______ _______ _______  _____  __   __
|_____| |     |    |    |     | |  |  | |_____|    |    |     | | \\\\  |
|     | |_____|    |    |_____| |  |  | |     |    |    |_____| |  \\\\_|
-----------------------------------------------------------------------
${VERSION} | 0bsd
"




# remove existing output directories
1>&2 printf -- "%s" "\

I: Purging Package Workspace Now...
"
rm -rf "$PROJECT_DIRECTORY_SRC" > /dev/null 2> /dev/null
rm -rf "$PROJECT_DIRECTORY_SHARE" > /dev/null 2> /dev/null
rm -rf "$PROJECT_DIRECTORY_PKG" > /dev/null 2> /dev/null
sync "$PROJECT_DIRECTORY_ROOT" > /dev/null 2> /dev/null
mkdir -p "$PROJECT_DIRECTORY_SRC"
mkdir -p "$PROJECT_DIRECTORY_SHARE"
mkdir -p "$PROJECT_DIRECTORY_PKG"




# package the source file now
printf -- "%s" "\
${PROJECT_DIRECTORY_INTERNAL}/automaton|:|${PROJECT_DIRECTORY_SRC}/.
${PROJECT_DIRECTORY_INTERNAL}/ci|:|${PROJECT_DIRECTORY_SRC}/.
${PROJECT_DIRECTORY_ROOT}/.github/workflows/git-push.yml|:|${PROJECT_DIRECTORY_SRC}/github-ci.yml
${PROJECT_DIRECTORY_ROOT}/.gitlab/ci.yml|:|${PROJECT_DIRECTORY_SRC}/gitlab-ci.yml
" | while IFS="" read -r ____line || [ -n "$____line" ]; do
	if [ "$____line" = "" ]; then
		continue
	fi

	## packing goodies
1>&2 printf -- "%s" "\

I: Packing '${____line%%"|:|"*}'...
"
	cp -r "${____line%%"|:|"*}" "${____line##*"|:|"}"
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: Failed to Package: '${____line%%"|:|"*}' to '${____line##*"|:|"}'
E: Unable to Proceed.
E: Bailing Out...

"
		exit 1
	fi
done
unset ____line




# package the documentation now
for ____item in "${PROJECT_DIRECTORY_ROOT}/README.md" \
"${PROJECT_DIRECTORY_ROOT}/REFERENCES.md" \
"${PROJECT_DIRECTORY_ROOT}/LICENSE.txt" \
"${PROJECT_DIRECTORY_ROOT}/CREATORS.txt" \
"${PROJECT_DIRECTORY_ROOT}/CONTRIBUTORS.txt" \
"${PROJECT_DIRECTORY_ROOT}/CITATION.cff" \
"${PROJECT_DIRECTORY_ROOT}/AI_DECREES.md" \
"${PROJECT_DIRECTORY_ROOT}/SECURITY.md"; do
	if [ ! -f "$____item" ]; then
		1>&2 printf -- "%s" "\
E: Missing Documentation Source: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"
		exit 1
	fi


	## filter all trademark banner off downstream
1>&2 printf -- "%s" "\

I: Packing '${____item}'...
"
	while IFS="" read -r ____line || [ -n "$____line" ]; do
		if [ ! "${____line%%".internals/trademarks/banner_1200x100.svg"*}" = "$____line" ]; then
			continue
		fi

		____item="${____item##*"$PROJECT_DIRECTORY_ROOT"}"
		____item="${____item="/"}"
		printf -- "%s\n" "$____line" \
			>> "${PROJECT_DIRECTORY_SRC%/}/${____item}"
		printf -- "%s\n" "$____line" \
			>> "${PROJECT_DIRECTORY_SHARE%/}/${____item}"
		printf -- "%s\n" "$____line" \
			>> "${PROJECT_DIRECTORY_PKG%/}/${____item%"."*}_${VERSION}.${____item#*"."}"
		if [ $? -ne 0 ]; then
			1>&2 printf -- "%s" "\
E: Failed to Package: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"
			exit 1
		fi
	done < "$____item"
done
unset ____item




# archive now
____pwd="$PWD"
cd "$PROJECT_DIRECTORY_SRC"
for ____item in \
"chewkeanho_automaton_${VERSION}_linux_all.tar.xz" \
"chewkeanho_automaton_${VERSION}_linux_all.tar.gz" \
"chewkeanho_automaton_${VERSION}_freebsd_all.tar.xz" \
"chewkeanho_automaton_${VERSION}_freebsd_all.tar.gz" \
"chewkeanho_automaton_${VERSION}_windows_all.zip" \
; do
	1>&2 printf -- "%s" "\

I: Archiving '${____item}'...
"
	case "$____item" in
	*".tar.xz")
		tar -cvJf "${PROJECT_DIRECTORY_PKG}/${____item}" *
		;;
	*".tar.gz")
		tar -cvzf "${PROJECT_DIRECTORY_PKG}/${____item}" *
		;;
	*".zip")
		zip -9 -r "${PROJECT_DIRECTORY_PKG}/${____item}" .
		;;
	*)
		;;
	esac

	if [ $? -ne 0 ]; then
		cd "$____pwd"
		1>&2 printf -- "%s" "\
E: Failed To Archive: './pkg/${____item}'
E: Unable to Proceed.
E: Bailing Out...

"

		unset ____pwd ____item
		exit 1
	fi
done
cd "$____pwd"
unset ____pwd




# signing artifacts
for ____item in "${PROJECT_DIRECTORY_PKG}/"*; do
	if [ ! -e "$____item" ]; then
		continue
	fi

	## gpg-sign
	1>&2 printf -- "%s" "\

I: GPG-Signing '${____item}'...
"
	gpg --armor --detach-sign "$____item"
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: Failed To GPG Sign: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"
	fi
done




# clean up
1>&2 printf -- "%s" "\

I: Cleaning Up...
"
rm -f "${PROJECT_DIRECTORY_SRC}/"* > /dev/null 2> /dev/null




# report status
1>&2 printf -- "%s" "\


S: Package Successful!
"
return 0
