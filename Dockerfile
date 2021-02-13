FROM	debian:buster
LABEL	maintainer="lburnet@student.42lyon.fr"

# WORKDIR	/usr/src/ft_server

# Vous devrez vous assurer que votre base de donnée SQL 
#fonctionne avec le wordpress et phpmyadmin.
#Vous devrez vous assurer que, selon l’url tapé, votre server redirige vers le bon site.
#Vous devrez aussi vous assurer que votre serveur tourne avec un index automatique qui doit pouvoir être désactivable.
RUN	apt-get -y update && apt-get -y upgrade \
		&& apt-get -y install gnupg wget nginx openssl mariadb-server mariadb-client \
		php7.3 php7.3-fpm php7.3-mysql php7.3-curl php7.3-mbstring php7.3-xml php7.3-gettext php7.3-cgi \
		&& wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz  \
		&& wget https://wordpress.org/wordpress-5.6.tar.gz

COPY	./srcs .

RUN	mkdir -p /var/www/html/phpmyadmin /etc/nginx/certificate /var/www/html/wordpress \
		&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin \
		&& tar xzvf wordpress-5.6.tar.gz --strip-components=1 -C /var/www/html/wordpress \
# config de Nginx
		&& rm -rf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default \
		&& cp nginx.conf /etc/nginx/sites-available/ \
	# des copains :	&& openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -out /etc/nginx/certificate/nginx-certificate.crt -keyout /etc/nginx/certificate/nginx.key \
		&& openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.localhost" -out /etc/nginx/certificate/lburnet_localhost-certificate.crt -keyout /etc/nginx/certificate/lburnet_localhost.key \
# config de mySQL
		&& service mysql start \
		&& mysql -u root < base.sql \
#		&& cp my.cnf /etc/mysql/my.cnf \
# config de phpMyAdmin
		&& rm /var/www/html/phpmyadmin/config.sample.inc.php \
		&& cp config.inc.php /var/www/html/phpmyadmin/ \
# config de wordpress
		&& cp config-localhost.php /var/www/html/wordpress \
		&& cp wp.conf /etc/nginx \
		&& chown -R www-data:www-data /var/www/html \
# nettoyage
		&& rm -rf base.sql config-localhost.php config.inc.php my.cnf nginx.conf wp.conf \
		&& rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz phpmyadmin.keyring wordpress-5.6.tar.gz

EXPOSE	80

EXPOSE	443

CMD	sh run.sh
