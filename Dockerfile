FROM docker.io/alpine:3.20
MAINTAINER Michal Hajek <michal.hajek@daktela.com>
LABEL description="Daktela sniff-dock"
LABEL org.opencontainers.image.authors="Michal Hajek <michal.hajek@daktela.com>"
LABEL org.opencontainers.image.source https://github.com/hajekmi/sniff-dock

WORKDIR /

COPY ./entrypoint.sh /entrypoint.sh

RUN \
    apk update && apk add tcpdump openssh bind-tools mtr nmap sngrep speedtest-cli iperf3 screen && \
    apk cache clean && \
    chmod +x /entrypoint.sh && mkdir -p /root/ssh && ln -s /root/ssh/sniff_dock_sshd.conf /etc/ssh/sshd_config.d/sniff_dock_sshd.conf && \
    rm -rf /var/cache/apk/* 

ENTRYPOINT [ "./entrypoint.sh" ]
