#syntax=docker/dockerfile:1
FROM ubuntu:18.04
RUN mkdir /app
COPY ./epikur4Server-21.2.0.2-all.deb /app
RUN apt install /app/epikur4Server-21.2.0.2-all.deb
RUN rm /app/epikur4Server-21.2.0.2-all.deb 

CMD /usr/share/epikur4Server/bin/start.sh
