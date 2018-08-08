FROM php:7.2.6-fpm-alpine3.6

RUN apk add --update icu-libs icu icu-dev

RUN set -xe \
    && apk add \
        --virtual .memcached-deps \
		icu-libs icu icu-dev \
        zlib-dev libmemcached-dev cyrus-sasl-dev git \
    && git clone --branch php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached/ \
			&& docker-php-source extract \
            && docker-php-ext-configure memcached \
            && docker-php-ext-install memcached zip \
			&& docker-php-source delete \
            && rm -rf /usr/src/php/ext/memcached \
            && apk del --no-cache libmemcached-dev \
            			zlib-dev cyrus-sasl-dev \
			&& rm -rf /usr/src/php/ext/memcached \
 			&& apk del libmemcached-dev zlib-dev cyrus-sasl-dev \
			&& apk add --update --virtual .build-deps\
					freetype-dev libjpeg-turbo-dev libpng-dev \
					libmcrypt-dev curl-dev libxpm-dev libxml2-dev \
					autoconf g++ imagemagick-dev \
					libtool make php7-dev \
				&& apk add php7-gd \
				&& docker-php-source extract \
				&& pecl update-channels \
				&& pecl install xdebug  redis mongodb igbinary msgpack \
				&& docker-php-ext-enable xdebug redis mongodb igbinary msgpack \
				&& docker-php-ext-configure gd \
					--with-gd \
					--with-freetype-dir=/usr/include/ \
					--with-jpeg-dir=/usr/include/ \
					--with-png-dir=/usr/include/ \
				&& docker-php-ext-install intl pdo pdo_mysql mysqli gd \
				&& docker-php-source delete \
				&& apk del .build-deps \
				&& rm -rf /tmp/pear/temp/

COPY php.ini /usr/local/etc/php/conf.d/settings.ini
COPY php-cacert.pem /usr/lib/ssl/cert.pem
COPY php-fpm-www.conf /usr/local/etc/php-fpm.d/www.conf

