#!/bin/sh

if [ -z "$UCARP_ADDR" ]; then
	echo "[-] UCARP_ADDR environment variable not set"
	exit 1
fi

if [ -z "$UCARP_INTERFACE" ]; then
	echo "[=] Guessing interface based on default route"
	UCARP_INTERFACE="$(ip route show | sed -n -r -e 's/^default via.*dev ([^ ]+).*/\1/p')"
	if [ -z "$UCARP_INTERFACE" ]; then
		echo "[-] Guessing interface failed"
		exit 2
	fi
	echo "[+] Guessed interface: $UCARP_INTERFACE"
fi

if [ -z "$UCARP_SRCIP" ]; then
	echo "[=] Guessing source ip on $UCARP_INTERFACE"
	UCARP_SRCIP="$(ip addr show dev $UCARP_INTERFACE | awk '/inet / {split($2, a, "/"); print a[1]; exit}')"
	if [ -z "$UCARP_SRCIP" ]; then
		echo "[-] Guessing source ip on $UCARP_INTERFACE failed"
		exit 3
	fi
	echo "[+] Guessed source ip on $UCARP_INTERFACE: $UCARP_SRCIP"
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
