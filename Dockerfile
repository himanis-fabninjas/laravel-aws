# Use official PHP image
FROM php:8.2-cli

# Install system packages
RUN apt-get update && apt-get install -y \
    unzip \
    zip \
    git \
    curl \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy composer files first
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy the rest of the application
COPY . .

# Set permissions
RUN chmod -R 775 storage bootstrap/cache

# Expose port
EXPOSE 80

# Start Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]
