#syntax=docker/dockerfile:1
FROM debian:bookworm
RUN mkdir /app
COPY ./epikur4Server-25.2.1.5-all.deb /app
RUN apt-get update && \
    apt-get install -y /app/epikur4Server-25.2.1.5-all.deb && \
    rm /app/epikur4Server-25.2.1.5-all.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/share/epikur4Server/bin/start.sh"]

