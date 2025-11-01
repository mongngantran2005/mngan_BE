# Dùng PHP 8.2 + Apache
FROM php:8.2-apache

# Cài các thư viện cần thiết cho Laravel + PHP Zip
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Copy toàn bộ code vào thư mục web
COPY . /var/www/html

WORKDIR /var/www/html

# Cài Composer và các package Laravel
RUN curl -sS https://getcomposer.org/installer | php -- \
    && mv composer.phar /usr/local/bin/composer \
    && composer install --no-dev --optimize-autoloader \
    && php artisan key:generate

# Phân quyền thư mục storage và cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Mở port 80 cho Render
EXPOSE 80

# Chạy Apache server
CMD ["apache2-foreground"]
