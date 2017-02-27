FROM ubuntu:15.10
MAINTAINER Helmi Ibrahim <helmi@tuxuri.com>

# RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list

ENV HTTP_PROXY http://srv-pxy00.tisseo-exp.dom:8080
ENV http_proxy http://srv-pxy00.tisseo-exp.dom:8080
ENV HTTPS_PROXY http://srv-pxy00.tisseo-exp.dom:8080
ENV https_proxy http://srv-pxy00.tisseo-exp.dom:8080
RUN apt-get -y update
RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN apt-get -y install postgresql-9.4 postgresql-contrib-9.4 postgresql-9.4-postgis-2.1 postgis
RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN service postgresql start && /bin/su postgres -c "createuser -d -s -r -l docker" && /bin/su postgres -c "psql postgres -c \"ALTER USER docker WITH ENCRYPTED PASSWORD 'docker'\"" && service postgresql stop
RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.4/main/postgresql.conf
RUN echo "port = 5432" >> /etc/postgresql/9.4/main/postgresql.conf

EXPOSE 5432

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]
