FROM debian:trixie
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y curl php php-mysql php-fpm mariadb-client
COPY ./tools/setup.sh /
RUN chmod +x /setup.sh
ENTRYPOINT [ "/setup.sh" ]
