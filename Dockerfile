FROM alpine:3.7

LABEL maintainer="andrey.mikhalchuk@conceptant.com"
LABEL version="0.0.1.1"
LABEL description="This Dockerfile builds BIND9"
LABEL "com.conceptant.vendor"="Conceptant, Inc."

COPY files .

RUN apk update \
    && apk add \
        bind \
        vim \
        bind-tools \
    && chmod +x entrypoint.sh

VOLUME /var/named /etc/bind

EXPOSE 53/tcp 53/udp

CMD ["/entrypoint.sh"]