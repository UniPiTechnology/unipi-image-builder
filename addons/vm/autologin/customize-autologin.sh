#!/bin/sh
# Copyright 2022-2023 Helmut Grohne <helmut@subdivi.de>
# SPDX-License-Identifier: MIT
#
# This is a mmdebstrap customize hook that configures automatic root login on a
# serial console. It also parses the TERM kernel cmdline and passes it as
# TERM to agetty. Since serial consoles do not transmit SIGWINCH, it causes
# the shell to run setterm -resize on interactive, serial logins.

set -eu

TARGET=$1

cat >"$TARGET/etc/profile.d/resize_serial_term.sh" <<'EOF'
if test -n "${TERM-}" && test -n "${PS1-}"; then
	case "$(tty)" in
		/dev/tty[0-9]*)
		;;
		/dev/tty*)
			# Assume that every other tty is serial and should be resized.
			setterm -resize
		;;
	esac
fi
EOF

if test "$(dpkg-query --root "$TARGET" -f '${db:Status-Status}' -W systemd-sysv 2>/dev/null)" = installed; then
	UNIT=serial-getty@.service

	mkdir "$TARGET/etc/systemd/system/$UNIT.d"

	(
		echo '[Service]'
		printf '%s\n' 'ExecStartPre=/bin/sed -n -e "s/^\\(.* \\)\\?\\(TERM=[^ ]*\\).*/\\2/w/run/debvmterm" /proc/cmdline'
		echo 'EnvironmentFile=-/run/debvmterm'
		echo 'ExecStart='
		sed -n 's,^ExecStart=-/sbin/agetty ,&-a root ,p' "$TARGET/lib/systemd/system/$UNIT"
	) > "$TARGET/etc/systemd/system/$UNIT.d/autologin.conf"

	exit 0
fi

if test "$(dpkg-query --root "$TARGET" -f '${db:Status-Status}' -W sysvinit-core 2>/dev/null)" = installed; then
	# shellcheck disable=SC2016  # intentional non-expansion
	echo 'C0:2345:respawn:/sbin/getty -8 --noclear --keep-baud -a root console 115200,38400,9600 $TERM' >> "$TARGET/etc/inittab"
	# delete tty1, which could be /dev/console
	sed -i -e '/^1:/d' "$TARGET/etc/inittab"

	exit 0
fi

if test "$(dpkg-query --root "$TARGET" -f '${db:Status-Status}' -W runit-init 2>/dev/null)" = installed; then
	if ! test -f "$TARGET/etc/sv/getty-ttyS0/run"; then
		echo "failed to guess serial console name for runit" 1>&2
		exit 1
	fi

	# shellcheck disable=SC2016  # intentional non-expansion
	sed -i \
		-e 's,exec.*/sbin/getty ,&-a root ,' \
		-e '/exec 1>&2/i: "${TERM:=$(sed -n -e '"'"'s/^\\(.* \\)\\?TERM=\\([^ ]*\\).*/\\2/p'"'"' /proc/cmdline)}"' \
		-e '/exec.*getty /s, \(vt100\)$, "${TERM:-\1}",' \
		"$TARGET/etc/sv/getty-ttyS0/run"
	exit 0
fi

echo "failed: init system not recognized by autologin customization" 1>&2
exit 1
