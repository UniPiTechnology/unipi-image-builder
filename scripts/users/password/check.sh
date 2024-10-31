#!/bin/bash
# Copyright (C) Unipi Technology spol. s r.o. - All Rights Reserved
# SPDX-License-Identifier: MIT
#
# @author Miroslav Ondra <ondra@unipi.technology>
# @author Unipi Technology <info@unipi.technology>
# @date 2024-10-07

# Script to encrypt password file

set -eu

#. "$PWD/.config"

# check and encrypt 
if ! [ -r "$PASSWD_FILE" ]; then
    echo "Missing password file ($PASSWD_FILE)" >&2
    exit 1
fi

PW=$(head -1 "$PASSWD_FILE")
if echo "$PW" | grep -qv '^\$[[:digit:]]\$'; then
    openssl passwd  -5 -stdin <<< "$PW" > "$PASSWD_FILE" || exit 1
    #mkpasswd -m sha256crypt "$PW" > "$PASSWD_FILE" || exit 1
elif [ $(wc -l <"$PASSWD_FILE") != "0" ]; then
    echo -n "$PW" > "$PASSWD_FILE"
fi
exit $?
