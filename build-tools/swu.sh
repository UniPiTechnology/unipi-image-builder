#!/bin/bash

set -eu

SRC=$(basename $1).gz
DST=$2

TMPDIR=$(mktemp -d)
if ! [ -d "${TMPDIR}" ]; then
    exit 1;
fi
trap 'rm -rf "${TMPDIR}"' EXIT

gzip - < "$1" > "$TMPDIR/$SRC"

cat <<EOF > "$TMPDIR/sw-description"

software =
{
	version = "12.0.0";
	description = "Firmware update for Unipi Edge PLC";

	hardware-compatibility: [ "1.0" ];

	edge = {

		images: ({
				filename = "${SRC}";
				device = "/dev/mmcblk0p2";
				compressed = "zlib";
				installed-directly = true;
			 }
		);
	};
}
EOF

( cd "$TMPDIR"
  echo -ne "sw-description\n$SRC\n" | cpio -H newc -o
) > $DST
