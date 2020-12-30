FROM bitnami/wordpress:5.6.0-debian-10-r8

RUN sed -i 's/^upload_max_filesize\s*=.*/upload_max_filesize=512M/' /opt/bitnami/php/etc/php.ini
RUN sed -i 's/^post_max_size\s*=.*/post_max_size=512M/' /opt/bitnami/php/etc/php.ini
RUN sed -i 's/^memory_limit\s*=.*/memory_limit=1024M/' /opt/bitnami/php/etc/php.ini
RUN sed -i 's/^max_execution_time\s*=.*/max_execution_time=1200/' /opt/bitnami/php/etc/php.ini
RUN sed -i 's/^max_input_time\s*=.*/max_input_time=1200/' /opt/bitnami/php/etc/php.ini
RUN echo "define( 'WP_MAX_MEMORY_LIMIT', '1024M' );" >> /opt/bitnami/wordpress/wp-config.php