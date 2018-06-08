FROM alpine:3.7

RUN apk --no-cache add curl bash openssh-client &&\
    curl -L https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | tar -xz -C /tmp/ &&\
    mv /tmp/docker/docker /usr/bin/docker &&\
    rm -rf /tmp/docker &&\
    chmod +x /usr/bin/docker

ADD ./docker-entrypoint.sh ./docker-over-ssh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]