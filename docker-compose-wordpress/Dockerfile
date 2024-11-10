FROM wordpress:6.4.3-apache

# Try both paths to be sure
COPY wp-content /var/www/html/wp-content/
COPY wp-content /usr/src/wordpress/wp-content/

RUN chown -R www-data:www-data /var/www/html/wp-content \
    && chown -R www-data:www-data /usr/src/wordpress/wp-content \
    && chmod -R 755 /var/www/html/wp-content \
    && chmod -R 755 /usr/src/wordpress/wp-content

# Debug: Show both locations
RUN ls -la /var/www/html/wp-content/ && \
    ls -la /usr/src/wordpress/wp-content/