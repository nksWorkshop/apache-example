#FROM gitpod/workspace-full:latest
#FROM gitpod/workspace-mysql
FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y python-software-properties
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php5.6 
RUN apt-get -y upgrade
