#FROM gitpod/workspace-full:latest
#FROM gitpod/workspace-mysql
FROM ubuntu:16.04
RUN apt-get update
RUN apt -y install software-properties-common dirmngr apt-transport-https lsb-release ca-certificates
RUN apt-get install -y python-software-properties
#RUN touch /etc/apt/sources.list.d/ondrej-php5.list
#RUN echo "deb http://ppa.launchpad.net/ondrej/php5/ubuntu trusty main" >> /etc/apt/sources.list.d/ondrej-php5.list
#RUN echo "deb-src http://ppa.launchpad.net/ondrej/php5/ubuntu trusty main" >> /etc/apt/sources.list.d/ondrej-php5.list
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
#RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php5.6 
# RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget mysql-client mysql-server apache2 libapache2-mod-php5.6 php5.6-mysql pwgen python-setuptools vim-tiny php5.6-ldap unzip
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
#RUN sudo cd /var/www/hackazon/assets/config/ && \
#    cp auth.sample.php auth.php && \
#    cp email.sample.php email.php && \
#    cp rest.sample.php rest.php
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
RUN sudo chown gitpod:gitpod /etc/hosts
RUN sudo chown -R gitpod:gitpod /var/www/
RUN sudo chown -R gitpod:gitpod /var/www/hackazon/web/products_pictures/
RUN sudo chown -R gitpod:gitpod /var/www/hackazon/web/upload
RUN sudo chown -R gitpod:gitpod /var/www/hackazon/assets/config
RUN sudo chmod 755 /start.sh
RUN sudo chmod 755 /etc/apache2/foreground.sh
RUN sudo a2enmod rewrite 
RUN sudo mkdir /var/log/supervisor/
#RUN sudo mysqld --daemonize --skip-grant-tables \
#    && sleep 3 \
#    && ( mysql -uroot -e "USE mysql; UPDATE user SET authentication_string=PASSWORD(\"root\") WHERE user='root'; UPDATE user SET plugin=\"mysql_native_password\" WHERE user='root'; FLUSH PRIVILEGES;" ) \
#    && mysqladmin -uroot -proot shutdown;

EXPOSE 8000
CMD ["/bin/bash", "/start.sh"]
# optional: use a custom apache config.
#COPY ./apache/apache.conf /etc/apache2/apache2.conf
RUN sudo chown gitpod:gitpod /etc/apache2/apache2.conf

# optional: change document root folder. It's relative to your git working copy.
ENV APACHE_DOCROOT_IN_REPO="www"


sudo apt -y install software-properties-common dirmngr apt-transport-https lsb-release ca-certificates
