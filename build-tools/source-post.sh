#!/bin/bash
# Copyright (C) Unipi Technology spol. s r.o. - All Rights Reserved
# SPDX-License-Identifier: MIT
#
# @author Miroslav Ondra <ondra@unipi.technology>
# @author Unipi Technology <info@unipi.technology>
# @date 2024-10-07

# Script to convert tar file to ext2/ext4 image. Size is 110% of tar file size.
# Exclude content of directory /boot/firmware

set -eu

if [ -d "$1/etc/apt/sources.list.dd" ]; then
    find "$1/etc/apt/sources.list.dd/" -name \*.list -exec mv \{\} "$1/etc/apt/sources.list.d" \;
    rm -rf "$1/etc/apt/sources.list.dd/"
fi
#find "$1/etc/apt/sources.list.d" -name \*.list -exec sed "s#signed-by=$1#signed-by=#" -i \{\} \;
shopt -s nullglob
if cd "$1/etc/apt/sources.list.d"; then
    for i in *.list; do
        if grep -q '^#TEMPORARY#' "$i"; then
            rm "$i"
        else
            sed "s#signed-by=$1#signed-by=#" -i "$i"
        fi
    done
fi
shopt -u nullglob
