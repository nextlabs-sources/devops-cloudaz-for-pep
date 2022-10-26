FROM postgres:9.5
MAINTAINER Nextlabs
COPY create-user-db.sql /tmp/
COPY init-user-db.sh /docker-entrypoint-initdb.d/
