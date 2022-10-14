FROM alpine:3.16.2

LABEL org.opencontainers.image.authors "Richard Kojedzinszky <richard@kojedz.in>"
LABEL org.opencontainers.image.source https://github.com/kubernetize/ucarp

RUN \
   apk --no-cache add ucarp libcap && \
   setcap cap_net_raw+ep /usr/sbin/ucarp && \
   setcap cap_net_admin+ep $(readlink /sbin/ip) && \
   apk --no-cache del libcap

COPY assets/ /

ENV UCARP_VHID=1 UCARP_PASS=password UCARP_MASKLEN=32

USER 65534

CMD ["/usr/local/sbin/ucarp.sh"]
