FROM node:10.6.0-alpine

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /root
ENV COMPOSER_VERSION 1.8.4

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
    jpegoptim \
    php7 \
    php7-curl \
    php7-iconv \
    php7-mbstring \
    php7-json \
    php7-openssl \
    php7-phar \
    php7-dom \
    php7-pdo \
    php7-pdo_mysql \
    php7-session \
    php7-gd \
    php7-fileinfo \
    php7-simplexml \
    php7-zip



## Install Composer
RUN curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer \
    && php -r " \
        \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
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
    && rm -rf /tmp/* \

RUN apk del -v .build-deps \
&& rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["node"]

