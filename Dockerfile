FROM alpine:3.22.1


ARG VERSION="0.0.0-dev"
ARG VCS_REF="unknown"
ARG CREATED="1970-01-01T00:00:00Z"


EXPOSE 80 443


# Setup apache and php
RUN apk --no-cache --update \
    add apache2 \
    apache2-ssl \
    curl \
    php82-apache2 \
    php82-bcmath \
    php82-bz2 \
    php82-calendar \
    php82-common \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-fileinfo \
    php82-gd \
    php82-iconv \
    php82-json \
    php82-mbstring \
    php82-mysqli \
    php82-mysqlnd \
    php82-openssl \
    php82-pdo_mysql \
    php82-pdo_pgsql \
    php82-pdo_sqlite \
    php82-phar \
    php82-session \
    php82-xml \
    php82-tokenizer \
    php82-zip \
    php82-xmlwriter \
    php82-redis \
    tzdata \
    && mkdir /htdocs

COPY linkstack /htdocs
COPY configs/apache2/httpd.conf /etc/apache2/httpd.conf
COPY configs/apache2/ssl.conf /etc/apache2/conf.d/ssl.conf
COPY configs/php/php.ini /etc/php8.2/php.ini

RUN chown apache:apache /etc/ssl/apache2/server.pem
RUN chown apache:apache /etc/ssl/apache2/server.key

RUN chown -R apache:apache /htdocs
RUN find /htdocs -type d -print0 | xargs -0 chmod 0755
RUN find /htdocs -type f -print0 | xargs -0 chmod 0644

COPY --chmod=0755 docker-entrypoint.sh /usr/local/bin/

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
