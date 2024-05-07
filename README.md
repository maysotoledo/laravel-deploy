
# Setup Docker Laravel 11 com PHP 8.3

### Passo a passo
Clone Repositório
```sh
git clone https://github.com/maysotoledo/laravel-producao.git
```
```sh
cd laravel-pro
```

Suba os containers do projeto
```sh
docker-compose up -d
```


Crie o Arquivo .env
```sh
cp .env.example .env
```

Acesse o container app
```sh
docker-compose exec app bash
```

Instale as dependências do projeto dentro do container
```sh
composer install
```

Gere a key do projeto Laravel
```sh
php artisan key:generate
```

Rodar as migrations
```sh
php artisan migrate
```
instalar Breezer
```sh
composer require laravel/breeze --dev

php artisan breeze:install
```

Acesse o projeto
[http://localhost:9000](http://localhost:9000)

# laravel11 em produçao para servidor VPS
