#!/bin/bash
set -e

VERSION=${VERSION:-latest}

UUID=${UUID:-$(uuid -v4)}

if [[ "${VERSION}" == "latest" ]]; then
    docker pull ghcr.io/charlesthomas/dev-box:latest
fi

PASSWORD=$UUID \
docker run \
--rm \
-p 127.0.0.1:8080:8080 \
-w /home/${USER} \
-v ${HOME}:/home/${USER}:Z \
-v ${HOME}/Library/Application\ Support/Code/User/keybindings.json:/home/${USER}/.local/share/code-server/User/keybindings.json:Z \
-v ${HOME}/Library/Application\ Support/Code/User/settings.json:/home/${USER}/.local/share/code-server/User/settings.json:Z \
-e DOCKER_USER=${USER} \
-e HOME=/home/${USER} \
-e PASSWORD \
-e TZ=America/Detroit \
-e USER=${USER} \
ghcr.io/charlesthomas/dev-box:${VERSION} \
&>> /tmp/code-server.log &

echo $UUID
