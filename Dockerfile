FROM ubuntu:jammy
ARG S6_OVERLAY_VERSION=3.1.2.1
ARG S6_ARCH=x86_64

COPY ./lighttpd.conf /tmp

RUN apt-get update && apt-get install -y lighttpd xz-utils nut-cgi
CMD ["/usr/sbin/lighttpd", "-D", "-f", "/tmp/lighttpd.conf"]

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz
ENTRYPOINT ["/init"]