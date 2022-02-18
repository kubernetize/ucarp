#!/bin/sh

if [ -z "$UCARP_ADDR" ]; then
	echo "[-] UCARP_ADDR environment variable not set"
	exit 1
fi

if [ -z "$UCARP_SRCIP" ]; then
	UCARP_SRCIP="$(ip addr show dev $UCARP_INTERFACE | awk '/inet / {split($2, a, "/"); print a[1]; exit}')"
fi

exec /usr/sbin/ucarp \
	--interface="$UCARP_INTERFACE" \
	--srcip="$UCARP_SRCIP" \
	--vhid="$UCARP_VHID" \
	--pass="$UCARP_PASS" \
	--addr="$UCARP_ADDR" \
	--upscript=/etc/ucarp/vip-up-default.sh \
	--downscript=/etc/ucarp/vip-down-default.sh \
	--shutdown \
	--xparam=32
