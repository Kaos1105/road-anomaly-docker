FROM php:8.3-fpm-alpine

RUN docker-php-ext-install pdo pdo_mysql

#PHP Extensions for Revern
RUN docker-php-ext-install pcntl
RUN docker-php-ext-configure pcntl --enable-pcntl

RUN apk update && apk add --no-cache supervisor

RUN mkdir -p "/etc/supervisor/logs"

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/supervisord.conf"]
