FROM alpine:3.12 AS base
RUN apk add --no-cache bash curl git openssh-client
ENV VERSION "20.10.2"
RUN curl -L -o /tmp/docker-$VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VERSION.tgz \
    && tar -xz -C /tmp -f /tmp/docker-$VERSION.tgz \
    && mv /tmp/docker/docker /usr/bin \
    && rm -rf /tmp/docker-$VERSION /tmp/docker

FROM certbot/dns-cloudflare:v1.12.0
COPY --from=base /usr/bin/docker /usr/bin
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]