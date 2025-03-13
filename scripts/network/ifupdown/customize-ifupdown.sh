#!/bin/sh
# Copyright 2023 Helmut Grohne <helmut@subdivi.de>
# SPDX-License-Identifier: MIT
#
# This is a mmdebstrap customize hook that configures ifupdown for dhcp.
# It expects ifupdown and isc-dhcp-client to be installed.

set -eu

TARGET=$1

IFFILE=interfaces
test -d "$TARGET/etc/network/interfaces.d" && IFFILE="interfaces.d/eth"

cat >"$TARGET/etc/network/$IFFILE" <<EOF
auto /enp*=eth
iface eth inet dhcp
EOF
