FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libmcrypt-dev \
    libicu-dev \
    libkrb5-dev \
    libssl-dev \
    zlib1g-dev \
    libmemcached-dev \
    libpq-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli intl zip opcache

RUN pecl install mailparse \
    && docker-php-ext-enable mailparse

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm"]
