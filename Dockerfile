FROM alpine:3.15.6

LABEL org.opencontainers.image.authors "Richard Kojedzinszky <richard@kojedz.in>"
LABEL org.opencontainers.image.source https://github.com/kubernetize/ucarp

RUN \
   apk --no-cache add ucarp iproute2 libcap && \
   setcap cap_net_raw+ep /usr/sbin/ucarp && \
   setcap cap_net_admin+ep /sbin/ip && \
   apk --no-cache del libcap

COPY assets/ /

ENV UCARP_VHID=1 UCARP_PASS=password

USER 65534

CMD ["/usr/local/sbin/ucarp.sh"]
