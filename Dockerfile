FROM php:7.4-alpine

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /root
ENV COMPOSER_VERSION 1.10.8

RUN apk --no-cache add \
    git \
    bash \
    openssh-client \
    zip \
    curl \
    zlib \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libpng \
    libpng-dev \
    libzip \
    libzip-dev \
    icu \
    icu-dev \
    jpegoptim \
    npm \
&& docker-php-source extract \
&& docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip \
    gd \
    intl \
    shmop \
    opcache \
&& docker-php-source delete


## Install Composer
RUN curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/2208570310e0b7d5683ba4f96dc8b95294e04914/web/installer \
    && php -r " \
        \$signature = 'baf1608c33254d00611ac1705c1d9958c817a1a33bce370c0595974b342601bd80b92a3f46067da89e3b06bff421f182'; \
        \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
        if (!hash_equals(\$signature, \$hash)) { \
            unlink('/tmp/installer.php'); \
            echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
            exit(1); \
        }" \
    && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && composer --ansi --version --no-interaction \
    && composer global require hirak/prestissimo \
    && rm -rf /root/.composer/cache/* \
    && rm -rf /tmp/*

RUN rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["node"]

