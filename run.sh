#!/bin/bash

VERSION=${VERSION:-latest}

NOW=${NOW:-$(date +%s)}
echo $NOW

if [ -z $PASSWORD ] && [ ! -f /tmp/code-server-pwd-${NOW} ]; then
    echo export PASSWORD
    exit 1
else
    echo -n "export PASSWORD=${PASSWORD}" >> /tmp/code-server-pwd-${NOW}
fi

source /tmp/code-server-pwd-${NOW}

TMP=/tmp/code-server-home-${NOW}
mkdir -p $TMP

docker run \
--rm \
-p 127.0.0.1:8080:8080 \
-v ${HOME}/code:/home/${USER}/code:Z \
-v ${TMP}:/home/${USER}:Z \
-v ${HOME}/.bw/env.sh:/home/${USER}/.bw/env.sh:Z \
-v ${HOME}/.local/share/code-server:/home/${USER}/.local/share/code-server:Z \
-v ${HOME}/Library/Application\ Support/Code/User/keybindings.json:/home/${USER}/.local/share/code-server/User/keybindings.json:Z \
-v ${HOME}/Library/Application\ Support/Code/User/settings.json:/home/${USER}/.local/share/code-server/User/settings.json:Z \
-e DOCKER_USER=${USER} \
-e HOME=/home/${USER} \
-e TZ=America/Detroit \
-e PASSWORD \
ghcr.io/charlesthomas/dev-box:${VERSION} \
&> /tmp/code-server-${NOW}.log &

echo http://localhost:8080/?folder=/home/${USER}
tail -f /tmp/code-server-${NOW}.log
