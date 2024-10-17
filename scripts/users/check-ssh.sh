#!/bin/sh

set -eu

#. $PWD/.config

if ! test -s "${ROOTKEY_FILE}" ; then
    echo "E: Missing SSH root public key file (${ROOTKEY_FILE})" >&2
    exit 1
fi
