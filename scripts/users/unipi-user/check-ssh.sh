#!/bin/sh

set -eu

#. $PWD/.config

if ! test -s "${UNIPI_ROOTKEY_FILE}" ; then
    echo "E: Missing SSH root public key file (${UNIPI_ROOTKEY_FILE})" >&2
    exit 1
fi
