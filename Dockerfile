# Use official PHP image with necessary extensions
FROM php:8.2-cli

# Install dependencies
RUN apt-get update && apt-get install -y unzip zip curl git libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy project files into container
COPY . .

# Set file permissions
RUN chmod -R 755 /var/www

# Expose Laravel default dev server port
EXPOSE 80

# Start Laravel dev server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]
