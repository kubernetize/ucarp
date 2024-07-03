FROM alpine:3.20.1 AS build

ARG TAG=f5a05b7fb90bf

RUN apk --no-cache add curl gcc libc-dev make autoconf automake libtool libpcap-dev tar && mkdir /src

WORKDIR /src

RUN curl -sL https://github.com/rkojedzinszky/UCarp/archive/${TAG}.tar.gz | tar xzf - --strip-components=1

RUN \
   autoreconf -si && \
   ./configure \
   --prefix=/usr \
   --sysconfdir=/etc \
   --disable-nls && \
   make && \
   make install-strip

FROM alpine:3.20.1

LABEL org.opencontainers.image.authors "Richard Kojedzinszky <richard@kojedz.in>"
LABEL org.opencontainers.image.source https://github.com/kubernetize/ucarp

COPY --from=build /usr/sbin/ucarp /usr/sbin/

RUN \
   apk --no-cache add ipcalc libpcap libcap && \
   setcap cap_net_raw+ep /usr/sbin/ucarp && \
   setcap cap_net_admin+ep $(readlink /sbin/ip) && \
   apk --no-cache del libcap

COPY assets/ /

USER 65534

CMD ["/usr/local/sbin/ucarp.sh"]
