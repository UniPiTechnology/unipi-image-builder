#!/bin/sh
# Copyright 2022 Helmut Grohne <helmut@subdivi.de>
# SPDX-License-Identifier: MIT
#
# This is a mmdebstrap customize hook that enables systemd-resolved on various
# Debian releases.

set -eu

TARGET=$1

LIBNSS_RESOLVE_VERSION=$(dpkg-query --root "$TARGET" -f '${Version}' -W libnss-resolve 2>/dev/null) || :

ls -l "$TARGET/etc/resolv.conf"

if dpkg --compare-versions "$LIBNSS_RESOLVE_VERSION" lt 251.3-2~exp1; then
	if test "${MMDEBSTRAP_MODE:-}" = chrootless; then
		systemctl --root "$TARGET" enable systemd-resolved.service
	else
		chroot "$TARGET" systemctl enable systemd-resolved.service
	fi

	if test -z "$LIBNSS_RESOLVE_VERSION" || dpkg --compare-versions "$LIBNSS_RESOLVE_VERSION" lt 236; then
		ln -fs ../run/systemd/resolve/resolv.conf "$TARGET/etc/resolv.conf"
	else
		ln -fs ../run/systemd/resolve/stub-resolv.conf "$TARGET/etc/resolv.conf"
	fi
fi

ls -l "$TARGET/etc/resolv.conf"
