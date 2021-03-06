ARG tag
FROM traefik:${tag}-alpine

ARG version
LABEL com.plasmops.vendor=PlasmOps \
      com.plasmops.version=$version

ENV LANG=C.UTF-8

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories ; \
    apk --no-cache --update --virtual .deps add curl && \
    apk --no-cache --update add tini logrotate && \
    cat /etc/logrotate.conf | sed -i 's/\(\/var\/log\/messages \){}/\1{\n  missingok \n}/'

COPY entrypoint.sh /
ENTRYPOINT [ "/sbin/tini", "--", "/entrypoint.sh" ]
CMD [ "traefik" ]
