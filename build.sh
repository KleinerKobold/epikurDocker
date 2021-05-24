#!/bin/bash

if [ ! -f ./epikur4Server-21.2.0.2-all.deb ]; then
    wget https://d3qdqfggaorxod.cloudfront.net/netzwerk/epikur4Server-21.2.0.2-all.deb
fi

docker build --pull --rm -f "Dockerfile" -t epikur:latest "."