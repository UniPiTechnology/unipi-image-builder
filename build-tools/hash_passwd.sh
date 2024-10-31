#!/bin/bash

set -eu

if [ -z "$1" ]; then
    echo "Missing required parameter" >&2
    exit 1
fi

configfile="$1"

. "$configfile"

if [ "$CONFIG_UNIPI_PASSWD" = "y" ]; then
    PW=$CONFIG_UNIPI_PASSWD_TEXT
    if echo "$PW" | grep -qv '^|[[:digit:]]|'; then
        HASHPW=$(openssl passwd -5 -stdin <<< "$PW" | sed 's/\$/|/g')
        sed "s#CONFIG_UNIPI_PASSWD_TEXT=.*\$#CONFIG_UNIPI_PASSWD_TEXT=\"$HASHPW\"#" -i "$configfile"
    fi
fi
if [ "$CONFIG_ROOT_PASSWD" = "y" ]; then
    PW=$CONFIG_ROOT_PASSWD_TEXT
    if echo "$PW" | grep -qv '^|[[:digit:]]|'; then
        HASHPW=$(openssl passwd -5 -stdin <<< "$PW" | sed 's/\$/|/g')
        sed "s#CONFIG_ROOT_PASSWD_TEXT=.*\$#CONFIG_ROOT_PASSWD_TEXT=\"$HASHPW\"#" -i "$configfile"
    fi
fi
