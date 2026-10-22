FROM alpine:3.23.4


ARG VERSION="0.0.0-dev"
ARG VCS_REF="unknown"
ARG CREATED="1970-01-01T00:00:00Z"


EXPOSE 80 443


# Setup apache and php
RUN apk --no-cache --update \
    add apache2 \
    apache2-ssl \
    curl \
    php83-apache2 \
    php83-bcmath \
    php83-bz2 \
    php83-calendar \
    php83-common \
    php83-ctype \
    php83-curl \
    php83-dom \
    php83-fileinfo \
    php83-gd \
    php83-iconv \
    php83-json \
    php83-mbstring \
    php83-mysqli \
    php83-mysqlnd \
    php83-openssl \
    php83-pdo_mysql \
    php83-pdo_pgsql \
    php83-pdo_sqlite \
    php83-phar \
    php83-session \
    php83-xml \
    php83-tokenizer \
    php83-zip \
    php83-xmlwriter \
    php83-redis \
    tzdata \
    && mkdir /htdocs

COPY linkstack /htdocs
COPY configs/apache2/httpd.conf /etc/apache2/httpd.conf
COPY configs/apache2/ssl.conf /etc/apache2/conf.d/ssl.conf
COPY configs/php/php.ini /etc/php83/conf.d/40-custom.ini

RUN chown apache:apache /etc/ssl/apache2/server.pem
RUN chown apache:apache /etc/ssl/apache2/server.key

RUN chown -R apache:apache /htdocs
RUN find /htdocs -type d -print0 | xargs -0 chmod 0755
RUN find /htdocs -type f -print0 | xargs -0 chmod 0644

COPY --chmod=0755 docker-entrypoint.sh /usr/local/bin/

RUN chmod -R 755 /etc/php83 && \
    chown -R apache:apache /etc/php83


USER apache:apache

HEALTHCHECK CMD curl -f http://localhost -A "HealthCheck" || exit 1

# Set console entry path
WORKDIR /htdocs

CMD ["docker-entrypoint.sh"]


LABEL maintainer="IlyaVassyutovich"
LABEL description="LinkStack Docker"

LABEL org.opencontainers.image.title="LinkStack"
LABEL org.opencontainers.image.description="A simple to set up docker variant of LinkStack"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/ilyavassyutovich/linkstack"
LABEL org.opencontainers.image.source="https://github.com/IlyaVassyutovich/linkstack-docker"
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.created=$CREATED
