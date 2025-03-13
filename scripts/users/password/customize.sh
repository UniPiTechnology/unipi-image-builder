#!/bin/sh
# Copyright (C) Unipi Technology spol. s r.o. - All Rights Reserved
# SPDX-License-Identifier: MIT
#
# @author Miroslav Ondra <ondra@unipi.technology>
# @author Unipi Technology <info@unipi.technology>
# @date 2024-10-07

# This is mmdebstrap customize hook to set root password

if [ "$ROOT_PASSWD" = "y" ]; then
    if echo "$ROOT_PASSWD_TEXT" | grep -q '^|[[:digit:]]|'; then
        PW=$(echo "$ROOT_PASSWD_TEXT" | sed 's/|/$/g')
    else
        PW=$(echo "$ROOT_PASSWD_TEXT" | openssl passwd -5 -stdin)
    fi
    echo "root:$PW" | /sbin/chpasswd -R "$1" -e
fi
