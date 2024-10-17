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

SRC="$1"
SRCNAME=$(basename "$1")
BUILDDIR=${BUILDDIR-build}

if ! [ -r "$SRC/source" ]; then
    echo "Missing file $SRC/source" >&2
    exit 1
fi

( cat <<EOF
#!/bin/bash

set -eu

if [ "\${MMDEBSTRAP_VERBOSITY:-1}" -ge 3 ]; then
    set -x
fi

TARGET="\$1"
EOF

# shellcheck disable=SC2016
echo 'mkdir -p "$TARGET/etc/apt/sources.list.d"'
# shellcheck disable=SC2016
echo 'cat <<EOF > "$TARGET/etc/apt/sources.list.d/'"$SRCNAME.list"'"'
if [ -x "$SRC/source" ]; then
    "$SRC/source"
else
    cat "$SRC/source"
fi
echo "EOF"

if [ -r "$SRC/keyring" ]; then
    # shellcheck disable=SC2016
    echo 'mkdir -p "$TARGET/etc/apt/keyrings"'
    # shellcheck disable=SC2016
    echo 'cat <<EOF > "$TARGET/etc/apt/keyrings/'"$SRCNAME.asc"'"'
    if [ -x "$SRC/keyring" ]; then
        "$SRC/keyring"
    else
        cat "$SRC/keyring"
    fi
    echo "EOF"
    # shellcheck disable=SC2016
    echo 'sed "s#^deb#deb [signed-by=$TARGET/etc/apt/keyrings/'"$SRCNAME.asc"'] #" -i "$TARGET/etc/apt/sources.list.d/'"$SRCNAME.list"'"'
fi

if [ -r "$SRC/pref" ]; then
    # shellcheck disable=SC2016
    echo 'mkdir -p "$TARGET/etc/apt/preferences.d"'
    # shellcheck disable=SC2016
    echo 'cat <<EOF > "$TARGET/etc/apt/preferences.d/'"$SRCNAME.pref"'"'
    if [ -x "$SRC/pref" ]; then
        "$SRC/pref"
    else
        cat "$SRC/pref"
    fi
    echo "EOF"
fi

) > "$BUILDDIR/.$SRCNAME"
chmod +x "$BUILDDIR/.$SRCNAME"
