#!/bin/bash

if [ -z "${SSH_KEY}" ]; then
    echo 'Missing SSH_KEY env variable. Try doing SSH_KEY=$(cat my-ssh-key | tr "\n" ",")'
else
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    if [ ! -f ~/.ssh/id_rsa ]; then
        echo $SSH_KEY | tr ${NEWLINE_CHAR:-,} '\n' > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
    fi
fi

[ -z ${DOCKER_REMOTE_HOST} ] && echo "Missing DOCKER_REMOTE_HOST env variable." && exit 1
[ -e "/var/run/docker.sock" ] && rm -f /var/run/docker.sock

if [ "$#" -eq 0 ]; then
    exec ssh -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes -nNT -L /var/run/docker.sock:${REMOTE_DOCKER_SOCK_PATH:-"var/run/docker.sock"} ${DOCKER_REMOTE_HOST}
else
    ssh -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes -nNT -L /var/run/docker.sock:${REMOTE_DOCKER_SOCK_PATH:-"var/run/docker.sock"} ${DOCKER_REMOTE_HOST} &

    TIMEOUT=0
    until [ -e "/var/run/docker.sock" ] || [ $TIMEOUT -eq 30 ]; do
        sleep 0.1
        let "TIMEOUT+=1"
    done

    if [ ! -e /var/run/docker.sock ]; then
        echo "Couldnt connect to remote host."
        exit 2
    else
	export DOCKER_HOST="unix:///var/run/docker.sock"
        if [ "$1" == "background" ]; then
            echo "Running SSH tunnel in background..."
        else
            exec $@
        fi
    fi
fi
