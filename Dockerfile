FROM	debian:buster

# WORKDIR	/usr/src/ft_server

# Vous devrez vous assurer que votre base de donnée SQL 
#fonctionne avec le wordpress et phpmyadmin.
#Votre serveur devra pouvoir, quand c’est possible, utiliser le protocole SSL.
#Vous devrez vous assurer que, selon l’url tapé, votre server redirige vers le bon site.
#Vous devrez aussi vous assurer que votre serveur tourne avec un index automatique qui doit pouvoir être désactivable.
RUN	apt-get -y update && apt-get -y upgrade \
		&& apt-get -y install gnupg wget curl nginx default-mysql-server tar \
		php php-mysql php-pear php-curl php-mbstring php-xml php-gettext php-cgi \
		&& wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz  \
		&& wget https://files.phpmyadmin.net/phpmyadmin.keyring \
		&& wget -c https://wordpress.org/latest.tar.gz

COPY	./srcs .
# les lignes commentees ne fonctionnent pas
RUN	cp nginx.conf /etc/nginx
# RUN mysql -u root
RUN cp my.cnf /etc/mysql/my.cnf \
		&& gpg --import phpmyadmin.keyring
RUN tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
RUN cp config.inc.php /var/www/html/phpmyadmin/
# RUN chmod 660 /var/www/html/phpmyadmin/config.inc.php
# RUN chown –R www-data:www-data /var/www/html/phpmyadmin
# RUN tar xzvf latest.tar.gz --strip-components=1 -C /var/www/html/wordpress
RUN cp config-localhost.php /var/www/html/wordpress \
		&& cp wp.conf /etc/nginx
# RUN chown –R www-data:www-data /var/www/html/wordpress
RUN rm -rf config-localhost.php config.inc.php my.cnf nginx.conf wp.conf \
		&& rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz phpmyadmin.keyring latest.tar.gz

EXPOSE	80 443

# CMD
