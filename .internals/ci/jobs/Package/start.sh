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
	return 1
fi
PROJECT_DIRECTORY_ROOT="$PWD"
PROJECT_DIRECTORY_INTERNAL="${PROJECT_DIRECTORY_ROOT}/.internals"
PROJECT_DIRECTORY_BIN="${PROJECT_DIRECTORY_ROOT}/bin"
PROJECT_DIRECTORY_DOC="${PROJECT_DIRECTORY_ROOT}/share/doc/chewkeanho/software/automaton"
PROJECT_DIRECTORY_SRC="${PROJECT_DIRECTORY_ROOT}/src/chewkeanho/software/automaton"
PROJECT_DIRECTORY_LIB="${PROJECT_DIRECTORY_ROOT}/lib/chewkeanho/software/automaton"
PROJECT_DIRECTORY_TMP="${PROJECT_DIRECTORY_ROOT}/.local/tmp/automaton"
PROJECT_DIRECTORY_PKG="${PROJECT_DIRECTORY_ROOT}/pkg"




# all good - begin mission
PACKAGE_NAME="chewkeanho_automaton"
GPG_ID="49B7878749107ED9C456267ACFD3316C29873FB5"
VERSION="$(${PROJECT_DIRECTORY_ROOT}/.internals/automaton/Start.sh.ps1 version)"
VERSION="${VERSION%"
"}"




# checking dependencies
for ____command in "tar" "zip" "gpg" "rm" "sync" "mkdir" "cp" "git"; do
	1>&2 printf -- "%s" "\
I: Checking '${____command}' Dependency Now...
"
	command -v "$____command" > /dev/null 2> /dev/null
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: '${____command}' = MISSING
E: Unable to Proceed.
E: Bailing Out...

"
		return 1
	else
		1>&2 printf -- "%s" "\
I: '${____command}' = OK
"
	fi
done




# checking GPG key availability
1>&2 printf -- "%s" "\
I: Checking GPG Signing Key...
"
____can_gpg=true
gpg --list-secret-keys "$GPG_ID" > /dev/null 2> /dev/null
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
I: GPG Signing Is Not Possible.
"
	____can_gpg=false
fi




# remove existing output directories
for ____item in "$PROJECT_DIRECTORY_BIN" \
"$PROJECT_DIRECTORY_SRC" \
"$PROJECT_DIRECTORY_LIB" \
"$PROJECT_DIRECTORY_DOC" \
"$PROJECT_DIRECTORY_TMP" \
"$PROJECT_DIRECTORY_PKG" \
; do
	1>&2 printf -- "%s" "\
I: Purging '${____item}' now...
"
	rm -rf "$____item" > /dev/null 2> /dev/null
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"
		return 1
	fi

	sync "${____item%/*}" > /dev/null 2> /dev/null
	if [ $? -ne 0 ]; then
		sync > /dev/null 2> /dev/null
	fi

	1>&2 printf -- "%s" "\
I: Re-Creating '${____item}' now...
"
	mkdir -p "$____item" > /dev/null 2> /dev/null
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"
		return 1
	fi
done




# package the source file now
while IFS="" read -r ____line || [ -n "$____line" ]; do
	if [ "$____line" = "" ]; then
		continue
	fi

	## packing goodies
1>&2 printf -- "%s" "\
I: Packing '${____line%%"|::|"*}' to '${____line##*"|::|"}' ...
"
	cp -r "${____line%%"|::|"*}" "${____line##*"|::|"}"
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"
		return 1
	fi
done<<EOF
${PROJECT_DIRECTORY_INTERNAL}/automaton|::|${PROJECT_DIRECTORY_SRC%/*}
${PROJECT_DIRECTORY_INTERNAL}/automaton|::|${PROJECT_DIRECTORY_LIB%/*}
${PROJECT_DIRECTORY_INTERNAL}/automaton|::|${PROJECT_DIRECTORY_TMP}
${PROJECT_DIRECTORY_ROOT}/.github/workflows/git-push.yml|::|${PROJECT_DIRECTORY_TMP}/github-ci.yml
${PROJECT_DIRECTORY_ROOT}/.gitlab/ci.yml|::|${PROJECT_DIRECTORY_TMP}/gitlab-ci.yml
${PROJECT_DIRECTORY_INTERNAL}/automaton/entities/i18n/help|::|${PROJECT_DIRECTORY_DOC}
${PROJECT_DIRECTORY_INTERNAL}/automaton/Start.sh.ps1|::|${PROJECT_DIRECTORY_BIN}/chewkeanho-automaton
${PROJECT_DIRECTORY_INTERNAL}/automaton/Start.sh.ps1|::|${PROJECT_DIRECTORY_BIN}/chewkeanho-automaton.ps1
EOF




# organize payloads properly
	1>&2 printf -- "%s" "\
I: Re-Organizing '${PROJECT_DIRECTORY_TMP}/automaton'...
"
mkdir -p "${PROJECT_DIRECTORY_TMP}/internals"
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"
	return 1
fi


mv "${PROJECT_DIRECTORY_TMP}/automaton" "${PROJECT_DIRECTORY_TMP}/internals/."
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"
	return 1
fi


mkdir -p "${PROJECT_DIRECTORY_TMP}/internals/ci"
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"
	return 1
fi


for ____directory in "${PROJECT_DIRECTORY_INTERNAL}/ci/jobs/"*; do
	if [ ! -d "$____directory" ]; then
		continue
	fi

	1>&2 printf -- "%s" "\
I: Creating CI Job Template '${____directory}'...
"
	if [ ! -f "${____directory}/start.sh" ]; then
		1>&2 printf -- "%s" "\
E: Missing 'start.sh'.
E: Skipping...
"
		continue
	fi

	if [ ! -f "${____directory}/start.ps1" ]; then
		1>&2 printf -- "%s" "\
E: Missing 'start.sh'.
E: Skipping...
"
		continue
	fi

	____directory="${____directory##*/}"
	AUTOMATON_DIRECTORY_JOBS="${PROJECT_DIRECTORY_TMP}/internals/ci" \
		"${PROJECT_DIRECTORY_INTERNAL}/"automaton/Start.sh.ps1 \
			create \
			"$____directory"
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"
		return 1
	fi
done




# setup binary package
1>&2 printf -- "%s" "\
I: Configuring '${PROJECT_DIRECTORY_BIN}'...
"
for ____item in "${PROJECT_DIRECTORY_BIN}/"*; do
	if [ ! -e "$____item" ]; then
		continue
	fi

	case "${____item##*/}" in
	*.ps1)
		chmod -x "$____item"
		;;
	*)
		chmod +x "$____item"
		;;
	esac
done




# package the documentation now
for ____item in \
"${PROJECT_DIRECTORY_ROOT}/AI_DECREES.md" \
"${PROJECT_DIRECTORY_ROOT}/CHANGELOG.md" \
"${PROJECT_DIRECTORY_ROOT}/CITATION.cff" \
"${PROJECT_DIRECTORY_ROOT}/CONTRIBUTORS.txt" \
"${PROJECT_DIRECTORY_ROOT}/CREATORS.txt" \
"${PROJECT_DIRECTORY_ROOT}/LICENSE.txt" \
"${PROJECT_DIRECTORY_ROOT}/README.md" \
"${PROJECT_DIRECTORY_ROOT}/REFERENCES.md" \
"${PROJECT_DIRECTORY_ROOT}/SECURITY.md" \
; do
	if [ ! -f "$____item" ]; then
		1>&2 printf -- "%s" "\
E: Missing Documentation Source: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"
		return 1
	fi

	## filter all trademark banner off downstream
1>&2 printf -- "%s" "\
I: Packing '${____item}'...
"
	while IFS="" read -r ____line || [ -n "$____line" ]; do
		if [ ! "${____line%%".internals/trademarks/banner_1200x100.svg"*}" = "$____line" ]; then
			continue
		fi

		____filename="${____item##*/}"
		____filename_only="${____filename%%.*}"
		____file_extension="${____filename#*.}"
		____item="${____item##*"$PROJECT_DIRECTORY_ROOT"}"
		____item="${____item%"/"}"

		for ____dest in \
		"${PROJECT_DIRECTORY_TMP%/}/${____item}" \
		"${PROJECT_DIRECTORY_DOC%/}/${____item}" \
		"${PROJECT_DIRECTORY_PKG%/}/${____filename_only}_${VERSION}.${____file_extension}"; do
			printf -- "%s\n" "$____line" >> "$____dest"
			if [ $? -ne 0 ]; then
			1>&2 printf -- "%s" "\
E: Failed to Package: '${PROJECT_DIRECTORY_ROOT}/${____item}'
E: Unable to Proceed.
E: Bailing Out...

"
				return 1
			fi
		done
	done < "$____item"
done




# archive now
____pwd="$PWD"
cd "$PROJECT_DIRECTORY_TMP"
for ____item in \
"${PACKAGE_NAME}_${VERSION}_linux_all.tar.xz" \
"${PACKAGE_NAME}_${VERSION}_linux_all.tar.gz" \
"${PACKAGE_NAME}_${VERSION}_freebsd_all.tar.xz" \
"${PACKAGE_NAME}_${VERSION}_freebsd_all.tar.gz" \
"${PACKAGE_NAME}_${VERSION}_windows_all.zip" \
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

		return 1
	fi
done
cd "$____pwd"




# cryptographically sign each payload
if [ "$____can_gpg" = "true" ]; then
	## signing artifacts
	for ____item in "${PROJECT_DIRECTORY_PKG}/"*; do
		if [ ! -e "$____item" ]; then
			continue
		fi

		### gpg-sign artifact item
		1>&2 printf -- "%s" "\
I: GPG-Signing '${____item}'...
"
		gpg --armor --local-user "$GPG_ID" --detach-sign "$____item"
		if [ $? -ne 0 ]; then
			1>&2 printf -- "%s" "\
E: Execution Failed.
E: Failed To GPG Sign: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"
			return 1
		fi
	done


	## export public key
	### !!! IMPORTANT !!!
	###	* DO NOT '--armor' it. Verify cannot work on armored keyring.
	1>&2 printf -- "%s" "\
I: Exporting GPG Public Key to '${PROJECT_DIRECTORY_PKG}/public-key.gpg'...
"
	gpg --output "${PROJECT_DIRECTORY_PKG}/public-key.gpg" \
		--export "$GPG_ID"
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"
		return 1
	fi
fi




# clean up
1>&2 printf -- "%s" "\
I: Cleaning Up...
"




# report status
1>&2 printf -- "%s" "\
S: Package Successful!
"
return 0
