#!/bin/sh

set -eu

#. $PWD/.config

if ! test -s "${ROOT_KEY_FILE}" ; then
    echo "E: Missing SSH root public key file (${ROOT_KEY_FILE})" >&2
    exit 1
fi
