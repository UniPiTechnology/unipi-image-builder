#!/bin/bash
# Copyright (C) Unipi Technology spol. s r.o. - All Rights Reserved
# SPDX-License-Identifier: MIT
#
# @author Miroslav Ondra <ondra@unipi.technology>
# @author Unipi Technology <info@unipi.technology>
# @date 2024-10-07

# Script to convert tar file to vfat image with size 150 MB.
# Only content of directory /boot/firmware is included

set -eu

if [ -z "$2" ] || [ -z "$1" ]; then
    echo "Missing source and destination" >&2
    exit 1
fi

SRCTAR=$1
DST=$2
SIZE=$((150*1024))

#truncate -s ">${SIZE}" "$DST"

TMPDIR=$(mktemp -d)
if ! [ -d "${TMPDIR}" ]; then
    exit 1;
fi

trap 'rm -rf "${TMPDIR}"' EXIT

tar x -f "$SRCTAR" -C "${TMPDIR}" ./boot/firmware/
#mkdir -p "${TMPDIR}"/boot/firmware
ls -l "${TMPDIR}"
/sbin/mkfs.vfat -C "$DST" "$SIZE"

mkdir "${TMPDIR}"/mnt
fusefat -o rw+ "$DST" "${TMPDIR}"/mnt
cp -r "${TMPDIR}/boot/firmware/"* "${TMPDIR}"/mnt
fusermount -u "${TMPDIR}"/mnt
