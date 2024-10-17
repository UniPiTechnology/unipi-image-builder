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
if ! [ -r "$UNIPI_PASSWD_FILE" ]; then
    echo "Missing password file ($UNIPI_PASSWD_FILE)" >&2
    exit 1
fi

PW=$(head -1 "$UNIPI_PASSWD_FILE")
if echo "$PW" | grep -qv '^\$[[:digit:]]\$'; then
    mkpasswd -m sha256crypt "$PW" > "$UNIPI_PASSWD_FILE" || exit 1
elif [ $(wc -l <"$UNIPI_PASSWD_FILE") != "0" ]; then
    echo -n "$PW" > "$UNIPI_PASSWD_FILE"
fi
exit $?
