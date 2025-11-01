# Dùng PHP 8.2 + Apache
FROM php:8.2-apache

# Cài đặt các thư viện cần thiết cho Laravel và PHP extensions
RUN apt-get update && apt-get install -y \
    zip unzip git curl \
    libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Copy toàn bộ source code vào thư mục web
COPY . /var/www/html

# Chuyển thư mục làm việc sang Laravel project
WORKDIR /var/www/html

# Cài đặt Composer và các package cần thiết của Laravel
RUN curl -sS https://getcomposer.org/installer | php -- \
    && mv composer.phar /usr/local/bin/composer \
    && composer install --no-dev --optimize-autoloader

# Thiết lập Apache trỏ vào thư mục public (Laravel)
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf \
    && a2enmod rewrite

# Phân quyền cho storage và bootstrap/cache (để tránh lỗi permission)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Mở port 80 cho Render
EXPOSE 80

# Chạy Apache server khi container khởi động
CMD ["apache2-foreground"]
