FROM alpine:3.15

RUN \
   apk --no-cache add ucarp iproute2 libcap && \
   setcap cap_net_raw+ep /usr/sbin/ucarp && \
   setcap cap_net_admin+ep /sbin/ip && \
   apk --no-cache del libcap

COPY assets/ /

ENV UCARP_INTERFACE=eth0 UCARP_VHID=1 UCARP_PASS=password

USER 65534

CMD ["/usr/local/sbin/ucarp.sh"]
