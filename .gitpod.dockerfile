#FROM gitpod/workspace-full:latest
#FROM gitpod/workspace-mysql
FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install python-software-properties
RUN add-apt-repository -y ppa:ondrej/php5-compat
RUN apt-get update
RUN apt-get install -y php5.6 
RUN apt-get -y upgrade
