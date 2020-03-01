FROM gitpod/workspace-full:latest

RUN sudo add-apt-repository -y ppa:ondrej/php
RUN sudo apt-get update

RUN sudo apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get -y install wget mysql-client mysql-server apache2 libapache2-mod-php php-mysql pwgen python-setuptools vim-tiny php-ldap unzip

# setup hackazon
RUN easy_install supervisor
ADD ./scripts/start.sh /start.sh
ADD ./scripts/passwordHash.php /passwordHash.php
ADD ./scripts/foreground.sh /etc/apache2/foreground.sh
ADD ./configs/supervisord.conf /etc/supervisord.conf
ADD ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN sudo a2dissite 000-default
RUN sudo a2ensite 000-default 
#RUN sudo ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN sudo rm -rf /var/www/
# ADD https://github.com/rapid7/hackazon/archive/master.zip /hackazon-master.zip
RUN sudo wget https://github.com/rapid7/hackazon/archive/master.zip -O /hackazon-master.zip
RUN sudo unzip /hackazon-master.zip -d /hackazon
RUN ls /
RUN sudo mkdir /var/www/
RUN sudo mv /hackazon/hackazon-master/ /var/www/hackazon
RUN sudo cp /var/www/hackazon/assets/config/db.sample.php /var/www/hackazon/assets/config/db.php
RUN sudo cp /var/www/hackazon/assets/config/email.sample.php /var/www/hackazon/assets/config/email.php
ADD ./configs/parameters.php /var/www/hackazon/assets/config/parameters.php
ADD ./configs/rest.php /var/www/hackazon/assets/config/rest.php
ADD ./configs/createdb.sql /var/www/hackazon/database/createdb.sql
RUN sudo apt-get install -y php-xml php-bcmath
RUN cd /var/www/hackazon && sudo php composer.phar self-update && sudo php composer.phar install -o --prefer-dist
#RUN sudo chown -R www-data:www-data /var/www/
#RUN sudo chown -R www-data:www-data /var/www/hackazon/web/products_pictures/
#RUN sudo chown -R www-data:www-data /var/www/hackazon/web/upload
#RUN sudo chown -R www-data:www-data /var/www/hackazon/assets/config
RUN sudo chown -R gitpod:gitpod /var/www/
RUN sudo chown -R gitpod:gitpod /var/www/hackazon/web/products_pictures/
RUN sudo chown -R gitpod:gitpod /var/www/hackazon/web/upload
RUN sudo chown -R gitpod:gitpod /var/www/hackazon/assets/config
RUN sudo chmod 755 /start.sh
RUN sudo chmod 755 /etc/apache2/foreground.sh
RUN sudo a2enmod rewrite 
RUN sudo mkdir /var/log/supervisor/

EXPOSE 8000
CMD ["/bin/bash", "/start.sh"]
# optional: use a custom apache config.
#COPY ./apache/apache.conf /etc/apache2/apache2.conf
RUN sudo chown gitpod:gitpod /etc/apache2/apache2.conf

# optional: change document root folder. It's relative to your git working copy.
ENV APACHE_DOCROOT_IN_REPO="www"
