docker run \
       --rm \
       -d \
       -v /home/oliver/docker/epikurDocker/EpikurServer:/root/EpikurServer \
       -p 9980:8080 \
       --name epikurServer \
       epikur:latest \
       /usr/share/epikur4Server/bin/start.sh