# kubernetize/ucarp

## Basic usage

Run ucarp in hostnetwork mode. Following environment variables control ucarp operation:

Variable | Description | Default value
-|-|-
UCARP_ADDR | Virtual IP Address | -
UCARP_MASKLEN | Virtual IP Address netmask length | __32__
UCARP_INTERFACE | Interface to run ucarp on | guessed from routing table
UCARP_SRCIP | Source IP address to use | guessed from $UCARP_INTERFACE
UCARP_VHID | Virtual host ID | __1__
UCARP_PASS | Password | __password__
UCARP_PASS_FILE | File containing password | -
UCARP_GARP_TIMEOUT | Timeout during sending GARP packets after becoming master | -

At least `UCARP_ADDR` must be specified. Also, recommended to specify `UCARP_PASS`. Specifying `UCARP_PASS_FILE` will override `UCARP_PASS`.

Capabilities `CAP_NET_RAW` and `CAP_NET_ADMIN` are needed for correct operation.

Example invocation:

```sh
docker run -it --rm -e UCARP_ADDR=10.10.10.10 -e UCARP_PASS=g3n3r4t3d --network host --cap-add CAP_NET_RAW --cap-add CAP_NET_ADMIN ghcr.io/kubernetize/ucarp
```

## Advanced usage

The image can also be run in its on network namespace too, possibly with additional network interfaces facing uplink or other networks (e.g. using multus-cni in Kubernetes to provide access to public network). Then ucarp must be told which interface to use, what ip address to advertise, and if desired, upon becoming master, set up a dedicated routing table for traffic originating from the advertised address. For this, additional variables can be defined:

Variable | Description | Default value
-|-|-
UCARP_RTABLE | Routing table to create and to place routes into | -
UCARP_RTABLE_NETWORK_LENGTH | Network length overriding __UCARP_MASKLEN__ in specific routing table | __UCARP_MASKLEN__
UCARP_GATEWAY | Default gateway for traffic originating from Virtual IP | -
UCARP_RULE_PRIORITY | Priority to use in lookup rule | -

At least `UCARP_RTABLE` must be set to an integer to enable this operation. Usually `2` will do, but if you have multiple ucarp containers in a Kubernetes POD, you must specify different IDs for each. Also you will probably want to set `UCARP_RTABLE_NETWORK_LENGTH` to real network netmask instead of the default __32__. Specify `UCARP_GATEWAY` to set up a default route in the selected routing table.
