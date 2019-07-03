#!/usr/bin/env sh

mkdir -p ~/.ssh

if [ ! -z "$DOCKER_SSH_KEY" ]; then
	echo -n "$DOCKER_SSH_KEY" | tr "," "\n" > ~/.ssh/id_rsa
else
	echo "Missing DOCKER_SSH_KEY variable."
	exit 1
fi

chmod 600 ~/.ssh/id_rsa

cat > ~/.ssh/config << EOF
Host *
    StrictHostKeyChecking no
EOF
chmod 400 ~/.ssh/config