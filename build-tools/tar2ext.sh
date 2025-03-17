#!/bin/bash
# Copyright (C) Unipi Technology spol. s r.o. - All Rights Reserved
# SPDX-License-Identifier: MIT
#
# @author Miroslav Ondra <ondra@unipi.technology>
# @author Unipi Technology <info@unipi.technology>
# @date 2024-10-07

# Script to convert tar file to ext2/ext4 image. Size is 110% of tar file size.

set -eu

if [ -z "$2" ] || [ -z "$1" ]; then
    echo "Missing source and destination" >&2
    exit 1
fi

SRCTAR=$1
DST=$2
EXT=${3-ext4}
SIZE=$(($(stat -c %s $SRCTAR)*15/10))

truncate -s ">${SIZE}" "$DST"

TMPDIR=$(mktemp -d)
if ! [ -d "${TMPDIR}" ]; then
    exit 1;
fi

trap 'rm -rf "${TMPDIR}"' EXIT

tar x -f "$SRCTAR" -C "${TMPDIR}"
mkdir -p "${TMPDIR}"/boot/firmware
echo "mke2fs in $DST"
/sbin/mke2fs -q -F -t "$EXT" -d "${TMPDIR}" "$DST"
