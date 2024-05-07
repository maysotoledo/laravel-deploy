# Use a imagem oficial do PHP com o FPM (FastCGI Process Manager)
FROM php:8.3-fpm

# set your user name, ex: user=mayso
ARG user=mayso
ARG uid=1000

# Instale as dependências necessárias
RUN apt-get update && \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        unzip \
        git \
        curl \
    	libonig-dev \
    	libxml2-dev \
    	zip \
    	libnss3-tools \
    	jq \
    	xsel \
    	nodejs \
    	npm



# Instale as extensões PHP necessárias
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip mbstring exif pcntl bcmath gd sockets

# Instale o composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Install redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Instale a biblioteca Intervention Image usando o Composer
RUN composer require intervention/image

# Instale as dependências necessárias para a extensão Imagick
RUN apt-get update && \
    apt-get install -y libmagickwand-dev --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Instale a extensão Imagick do PHP
RUN pecl install imagick && \
    docker-php-ext-enable imagick

# Limpe o cache de pacotes
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure o PHP-FPM
COPY docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/zzz_custom.conf

# Configure o PHP
COPY docker/php/php.ini /usr/local/etc/php/conf.d/zzz_custom.ini

# Copy custom configurations PHP
COPY docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

# Defina o diretório de trabalho padrão
WORKDIR /var/www/html

EXPOSE 9000

USER $user



