#!/bin/bash

VERSION=${VERSION:-latest}

if [ -z $PASSWORD ]; then
    echo export PASSWORD
    exit 1
fi

TMP=/tmp/code-server-$(date +%s)
mkdir -p $TMP

docker run \
--rm \
-p 127.0.0.1:8080:8080 \
-v ${TMP}:/home/${USER}:Z \
-v ${HOME}/code:/home/${USER}/code:Z \
-v ${HOME}/.bw/env.sh:/home/${USER}/.bw/env.sh:Z \
-v ${HOME}/.local/share/code-server:/home/${USER}/.local/share/code-server:Z \
-e DOCKER_USER=${USER} \
-e HOME=/home/${USER} \
-e TZ=America/Detroit \
-e PASSWORD \
ghcr.io/charlesthomas/dev-box:${VERSION} \
&> /tmp/code-server.log &

echo http://localhost:8080/?folder=/home/${USER}
