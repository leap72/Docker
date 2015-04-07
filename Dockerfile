# VERSION 0.0.1

FROM ubuntu:14.04
MAINTAINER Leap SOK <leap@sys-expert.com>

ENV DEBIAN_FRONTEND noninteractive

# Use APT-Cacher that can run faster
RUN  echo 'Acquire::http { Proxy "http://192.168.1.29:3142"; };' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update

# Install common packages
RUN apt-get install -y \
	curl \
	subversion \
	tar \
	unzip \
	wget \
	zip

# Install web environment
RUN apt-get install -y \
	apache2 \
	libapache2-mod-php5 \
	openssl \
	php5 \
	php5-cli \
	php5-mysql

# Enable apache modules
RUN a2enmod \
	actions \
	proxy_http \
	ssl

# Insert custom PHP settings
COPY files/php.ini /etc/php5/apache2/conf.d/php_custom.ini
CMD sed -i '/include_path = "/etc/php5/apache2/conf.d/php_custom.ini' /etc/php5/apache2/php.ini

EXPOSE 80
CMD ["/usr/sbin/apachectl -D FOREGROUND"]
