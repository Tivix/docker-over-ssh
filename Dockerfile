FROM docker:18.09

RUN apk --no-cache add bash openssh-client

ADD parse-ssh-key.sh /usr/local/bin
