FROM php:8.3-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# MacOS staff group's
RUN delgroup dialout
# User and Group Configuration
RUN addgroup -g ${GID} --system laravel
RUN adduser -G laravel --system -D -s /bin/sh -u ${UID} laravel

RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# Dependencies
RUN apk add --no-cache \
    curl \
    libzip-dev \
    unzip \
    zip \
    libpng \
    libpng-dev \
    jpeg-dev \
    oniguruma-dev \
    curl-dev \
    freetype-dev \
    build-base \
    autoconf \
    && rm -rf /var/cache/apk/*

# PHP Extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring zip pcntl curl
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Install phpredis
RUN pear update-channels
RUN pecl update-channels
RUN pecl install redis \
    && docker-php-ext-enable redis

# Opcache Extension
RUN docker-php-ext-install opcache

# Set User and Start PHP-FPM
USER laravel
CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
