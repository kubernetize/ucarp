# kubernetize/ucarp

Run ucarp in hostnetwork mode for real functionality. Following environment variables control ucarp
operation:

Variable | Description | Default value
-|-|-
UCARP_ADDR | Virtual IP Address | -
UCARP_INTERFACE | Interface to run ucarp on | guessed from routing table
UCARP_SRCIP | Source IP address to use | guessed from $UCARP_INTERFACE
UCARP_VHID | Virtual host ID | __1__
UCARP_PASS | Password | __password__
UCARP_PASS_FILE | File containing password | -

At least `UCARP_ADDR` must be specified. Also, recommended to specify `UCARP_PASS`. Specifying `UCARP_PASS_FILE` will override `UCARP_PASS`.

Capabilities `CAP_NET_RAW` and `CAP_NET_ADMIN` are needed for correct operation.

Example invocation:

```sh
$ docker run -it --rm -e UCARP_ADDR=10.10.10.10 -e UCARP_PASS=g3n3r4t3d --network host --cap-add CAP_NET_RAW --cap-add CAP_NET_ADMIN ghcr.io/kubernetize/ucarp
```
