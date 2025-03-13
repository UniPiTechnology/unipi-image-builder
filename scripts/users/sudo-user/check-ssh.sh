#!/bin/sh

set -eu

#. $PWD/.config

if ! test -s "${SUDO_KEY_FILE}" ; then
    echo "E: Missing SSH root public key file (${SUDO_KEY_FILE})" >&2
    exit 1
fi
