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
