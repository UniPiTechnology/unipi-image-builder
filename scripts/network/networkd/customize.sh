#!/bin/sh
# Copyright 2022 Helmut Grohne <helmut@subdivi.de>
# SPDX-License-Identifier: MIT
#
# This is a mmdebstrap customize hook that enables and configures
# systemd-networkd on various Debian releases.

set -eu

TARGET=$1

SYSTEMD_VERSION=$(dpkg-query --root "$TARGET" -f '${Version}' -W systemd)

if test "${MMDEBSTRAP_MODE:-}" = chrootless; then
	systemctl --root "$TARGET" enable systemd-networkd.service
else
	chroot "$TARGET" systemctl enable systemd-networkd.service
fi

if dpkg --compare-versions "$SYSTEMD_VERSION" lt 249; then
  # This anchor is included by default since bullseye. Fails DNSSEC
  # validation when missing.
  DNSOPT="DNSSECNegativeTrustAnchors=home.arpa"
else
  DNSOPT=""
fi

for i in $(find  "$1/lib/systemd/network" -name \*.template -printf "%P\n") ; do
    name=${i%.template}
    (
    sed '/^#/d' "$1/lib/systemd/network/$i"
    cat <<EOF
[Network]
DHCP=yes
MulticastDNS=yes
LinkLocalAddressing=fallback
$DNSOPT

[DHCPv4]
ClientIdentifier=mac
UseHostname=no
EOF
    )  > "$1/etc/systemd/network/20-$name.network"
done

## Create fallback rule for virtual ethernet in qemu
cat << EOF > "$1/etc/systemd/network/50-fallback.network"
[Match]
Name=en*
Name=eth*

[Network]
DHCP=yes
$DNSOPT

[DHCP]
UseDomains=yes
EOF
