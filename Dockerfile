FROM ubuntu:jammy
ARG S6_OVERLAY_VERSION=3.1.4.1
ARG TARGETARCH

COPY ./lighttpd.conf /tmp

RUN apt-get update && apt-get install -y lighttpd xz-utils nut-cgi curl
CMD ["/usr/sbin/lighttpd", "-D", "-f", "/tmp/lighttpd.conf"]

RUN case ${TARGETARCH} in \
    "amd64")  S6_ARCH=x86_64   ;; \
    "arm64")  S6_ARCH=aarch64  ;; \
esac \
&& curl https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz -L -s --output /tmp/s6-overlay-noarch.tar.xz \
&& curl https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz -L -s --output /tmp/s6-overlay-${S6_ARCH}.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz

ENTRYPOINT ["/init"]