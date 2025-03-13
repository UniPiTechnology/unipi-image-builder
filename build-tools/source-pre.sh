#!/bin/sh
# Copyright (C) Unipi Technology spol. s r.o. - All Rights Reserved
# SPDX-License-Identifier: MIT
#
# @author Miroslav Ondra <ondra@unipi.technology>
# @author Unipi Technology <info@unipi.technology>
# @date 2024-10-07

# Script to convert tar file to ext2/ext4 image. Size is 110% of tar file size.
# Exclude content of directory /boot/firmware


set -eu

#find "$1/etc/apt/sources.list.d" -name \*.list -exec sed "s#signed-by=#signed-by=$1#" \{\} \;
mkdir "$1/etc/apt/sources.list.dd"
find "$1/etc/apt/sources.list.d" -name \*.list -exec mv \{\} "$1/etc/apt/sources.list.dd" \;

mv "$1/etc/resolv.conf" "$1/etc/resolv.confconf"
echo "nameserver 8.8.8.8" > "$1/etc/resolv.conf"
