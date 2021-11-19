FROM php:8-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN mkdir -p /var/www/html/public
WORKDIR /var/www/html

# The MacOS staff group gid is 20, so is the dialout group in alpine linux. We're not using it, so we're just going to remove it.
RUN delgroup dialout

RUN addgroup -g ${GID} --system laravel
RUN adduser -G laravel --system -D -s /bin/sh -u ${UID} laravel

RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf

RUN docker-php-ext-install pdo pdo_mysql opcache

ADD opcache.ini /usr/local/etc/php/conf.d/opcache.ini

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]