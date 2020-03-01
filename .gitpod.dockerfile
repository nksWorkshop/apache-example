#FROM gitpod/workspace-full:latest
#FROM gitpod/workspace-mysql
FROM ubuntu:16.04
RUN apt-get update
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod 
#\
    # passwordless sudo for users in the 'sudo' group
    ## && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
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
RUN apt-get install -y php5.6-xml
# RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget mysql-client mysql-server apache2 libapache2-mod-php5.6 php5.6-mysql pwgen python-setuptools vim-tiny php5.6-ldap unzip
RUN easy_install supervisor
ADD ./scripts/start.sh /start.sh
ADD ./scripts/passwordHash.php /passwordHash.php
ADD ./scripts/foreground.sh /etc/apache2/foreground.sh
ADD ./configs/supervisord.conf /etc/supervisord.conf
ADD ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2dissite 000-default
RUN a2ensite 000-default 
#RUN sudo ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN rm -rf /var/www/
# ADD https://github.com/rapid7/hackazon/archive/master.zip /hackazon-master.zip
RUN wget https://github.com/rapid7/hackazon/archive/master.zip -O /hackazon-master.zip
RUN unzip /hackazon-master.zip -d /hackazon
RUN ls /
RUN mkdir /var/www/
RUN mv /hackazon/hackazon-master/ /var/www/hackazon
#RUN sudo cd /var/www/hackazon/assets/config/ && \
#    cp auth.sample.php auth.php && \
#    cp email.sample.php email.php && \
#    cp rest.sample.php rest.php
RUN cp /var/www/hackazon/assets/config/db.sample.php /var/www/hackazon/assets/config/db.php
RUN cp /var/www/hackazon/assets/config/email.sample.php /var/www/hackazon/assets/config/email.php
ADD ./configs/parameters.php /var/www/hackazon/assets/config/parameters.php
ADD ./configs/rest.php /var/www/hackazon/assets/config/rest.php
ADD ./configs/createdb.sql /var/www/hackazon/database/createdb.sql
RUN apt-get install -y php5.6-xml php5.6-bcmath
RUN cd /var/www/hackazon && php composer.phar self-update && php composer.phar install -o --prefer-dist
#RUN sudo chown -R www-data:www-data /var/www/
#RUN sudo chown -R www-data:www-data /var/www/hackazon/web/products_pictures/
#RUN sudo chown -R www-data:www-data /var/www/hackazon/web/upload
#RUN sudo chown -R www-data:www-data /var/www/hackazon/assets/config
RUN chown gitpod:gitpod /etc/hosts
RUN chown -R gitpod:gitpod /var/www/
RUN chown -R gitpod:gitpod /var/www/hackazon/web/products_pictures/
RUN chown -R gitpod:gitpod /var/www/hackazon/web/upload
RUN chown -R gitpod:gitpod /var/www/hackazon/assets/config
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN a2enmod rewrite 
RUN mkdir /var/log/supervisor/
RUN chown -R gitpod:gitpod /etc/apache2 /var/run/apache2 /var/lock/apache2 /var/log/apache2
USER gitpod
RUN export APACHE_SERVER_NAME=$(gp url 8001 | sed -e s/https:\\/\\/// | sed -e s/\\///)
RUN export APACHE_RUN_USER="gitpod"
RUN export APACHE_RUN_GROUP="gitpod"
RUN export APACHE_RUN_DIR=/var/run/apache2
RUN export APACHE_PID_FILE="$APACHE_RUN_DIR/apache.pid"
RUN export APACHE_LOCK_DIR=/var/lock/apache2
RUN export APACHE_LOG_DIR=/var/log/apache2
USER root
RUN mkdir /var/run/mysqld \
 && chown -R gitpod:gitpod /var/run/mysqld /usr/share/mysql /var/lib/mysql /var/log/mysql /etc/mysql
USER gitpod
RUN mysqld --daemonize --skip-grant-tables \
    && sleep 3 \
    && ( mysql -uroot -e "USE mysql; UPDATE user SET authentication_string=PASSWORD(\"root\") WHERE user='root'; UPDATE user SET plugin=\"mysql_native_password\" WHERE user='root'; FLUSH PRIVILEGES;" ) \
    && mysqladmin -uroot -proot shutdown;
#RUN sudo mysqld --daemonize --skip-grant-tables \
#    && sleep 3 \
#    && ( mysql -uroot -e "USE mysql; UPDATE user SET authentication_string=PASSWORD(\"root\") WHERE user='root'; UPDATE user SET plugin=\"mysql_native_password\" WHERE user='root'; FLUSH PRIVILEGES;" ) \
#    && mysqladmin -uroot -proot shutdown;
USER root
EXPOSE 8000
CMD ["/bin/bash", "/start.sh"]
# optional: use a custom apache config.
#COPY ./apache/apache.conf /etc/apache2/apache2.conf
RUN chown gitpod:gitpod /etc/apache2/apache2.conf

# optional: change document root folder. It's relative to your git working copy.
ENV APACHE_DOCROOT_IN_REPO="www"


#sudo apt -y install software-properties-common dirmngr apt-transport-https lsb-release ca-certificates
