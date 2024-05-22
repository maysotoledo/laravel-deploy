# Use a imagem oficial do PHP com FPM (FastCGI Process Manager)
FROM php:8.3-fpm

# Atualiza a lista de pacotes e instala as dependências necessárias
RUN apt-get update && apt-get install -y \
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
    npm \
    libicu-dev \
    zlib1g-dev \
    libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*

# Configura e instala as extensões PHP necessárias
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip mbstring exif pcntl bcmath sockets intl

# Instala o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala a extensão Redis
RUN pecl install -o -f redis \
    && docker-php-ext-enable redis

# Instala a biblioteca Intervention Image usando o Composer
RUN composer require intervention/image

# Instala a extensão Imagick do PHP
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Limpa o cache de pacotes
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copia as configurações PHP-FPM
COPY docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/zzz_custom.conf

# Copia as configurações PHP
COPY docker/php/php.ini /usr/local/etc/php/conf.d/zzz_custom.ini

# Copia configurações PHP personalizadas
COPY docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

# Cria um usuário do sistema para executar os comandos do Composer e Artisan
ARG user=mayso
ARG uid=1000
RUN useradd -G www-data,root -u $uid -d /home/$user $user \
    && mkdir -p /home/$user/.composer \
    && chown -R $user:$user /home/$user

# Define o diretório de trabalho padrão
WORKDIR /var/www/html

# Altera o usuário para o usuário criado
USER $user

