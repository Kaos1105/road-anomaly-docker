# Use Debian slim as base image
FROM debian:stable-slim

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# Install Apache, PHP, and other dependencies
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-fcgid \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite proxy_fcgi

# Create a user with the specified UID and GID
RUN usermod -u $UID www-data && groupmod -g $GID www-data

# Set environment variable for custom document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Update the default Apache configuration to use the new document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set working directory
WORKDIR /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80 (Apache default)
EXPOSE 80

# Start Apache when container starts
CMD ["apachectl", "-D", "FOREGROUND"]
