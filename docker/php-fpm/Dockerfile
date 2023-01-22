FROM php:8.2-fpm
WORKDIR "/srv"

RUN apt-get update; \
    apt-get -y --no-install-recommends install \
        git \
        php8.2-pgsql \
        php8.2-redis \
        php8.2-xdebug; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

COPY xdebug.ini "${PHP_INI_DIR}/conf.d"

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

