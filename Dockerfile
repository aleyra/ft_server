FROM	debian:buster
LABEL	maintainer="lburnet@student.42lyon.fr"

# WORKDIR	/usr/src/ft_server

RUN	apt-get -y update && apt-get -y upgrade \
		&& apt-get -y install gnupg wget expect nginx openssl mariadb-server mariadb-client \
		php7.3 php7.3-fpm php7.3-mysql php7.3-curl php7.3-mbstring php7.3-xml php7.3-gettext php7.3-cgi \
		&& wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz  \
		&& wget https://wordpress.org/wordpress-5.6.1.tar.gz

COPY	./srcs .

RUN	mkdir -p /var/www/html/phpmyadmin /etc/nginx/certificate /var/www/html/wordpress \
		&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin \
		&& tar xzvf wordpress-5.6.1.tar.gz --strip-components=1 -C /var/www/html/wordpress \
# config de Nginx
		&& rm -rf /etc/nginx/sites-available/default \
		&& cp nginx.conf /etc/nginx/sites-available/default \
		&& openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.localhost" -out /etc/nginx/certificate/lburnet_localhost-certificate.crt -keyout /etc/nginx/certificate/lburnet_localhost.key \
# config de mySQL
		&& service mysql start \
		&& sh mysql_install.sh \
		&& mysql -u root < base.sql \
		&& mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql \
# config de phpMyAdmin
		&& rm /var/www/html/phpmyadmin/config.sample.inc.php \
		&& cp config.inc.php /var/www/html/phpmyadmin/ \
# config de wordpress
		&& cp wp-config.php /var/www/html/wordpress \
		&& chown -R www-data:www-data /var/www/html \
# nettoyage
		&& rm -rf base.sql config.inc.php mysql_install.sh nginx.conf wp-config.php \
		&& rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz phpmyadmin.keyring wordpress-5.6.1.tar.gz

EXPOSE	80

EXPOSE	443

CMD	sh run.sh
