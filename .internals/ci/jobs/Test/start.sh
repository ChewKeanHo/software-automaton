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




# check XuanQi's health and status
1>&2 printf -- "%s" "\
I: Checking Automaton's Usability...
"
if [ ! -x "./.internals/automaton/Start.sh.ps1" ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed (file).
E: Are You At Repository's Root Directory?
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's Help API...
"
./.internals/automaton/Start.sh.ps1 help
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's Create Help API...
"
./.internals/automaton/Start.sh.ps1 help create
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's Delete Help API...
"
./.internals/automaton/Start.sh.ps1 help delete
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's License Help API...
"
./.internals/automaton/Start.sh.ps1 help license
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's List Help API...
"
./.internals/automaton/Start.sh.ps1 help list
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's Version Run API...
"
./.internals/automaton/Start.sh.ps1 help run
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's Version Help API...
"
./.internals/automaton/Start.sh.ps1 help version
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's Version API...
"
_version="$(./.internals/automaton/Start.sh.ps1 version)"
1>&2 printf -- "%s" "\
I: Got '${_version}'
"
if [ "$_version" = "" ]; then
	unset _version
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's License API...
"
_license="$(./.internals/automaton/Start.sh.ps1 license)"
1>&2 printf -- "%s" "\
I: Got '${_license}'
"
if [ "$_license" = "" ]; then
	unset _license
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi
unset _license




1>&2 printf -- "%s" "\
I: Testing Automaton's Create API...
"
_name="Wanda"
./.internals/automaton/Start.sh.ps1 create "$_name"
if [ $? -ne 0 ]; then
	unset _name
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's List API...
"
_list="$(./.internals/automaton/Start.sh.ps1 list)"
1>&2 printf -- "%s" "\
I: Got '${_list}'
"
case "$_list" in
*"$_name"*)
	;;
*)
	1>&2 printf -- "%s" "\
E: Execution Failed (Missing '${_name}').
E: Unable to Proceed.
E: Bailing Out...
"
	unset _list _name
	return 1
	;;
esac
unset _list




1>&2 printf -- "%s" "\
I: Testing Automaton's Delete API...
"
./.internals/automaton/Start.sh.ps1 delete "$_name"
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	unset _name
	return 1
fi




1>&2 printf -- "%s" "\
I: Testing Automaton's List API...
"
_list="$(./.internals/automaton/Start.sh.ps1 list)"
1>&2 printf -- "%s" "\
I: Got '${_list}'
"
case "$_list" in
*"$_name"*)
	1>&2 printf -- "%s" "\
E: Execution Failed ('${_name}' Still Exists).
E: Unable to Proceed.
E: Bailing Out...
"
	unset _name _list
	return 1
	;;
*)
	;;
esac
unset _list _name





# report status
return 0
