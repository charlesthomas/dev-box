#!/bin/bash
set -e

VERSION=${VERSION:-latest}

UUID=${UUID:-$(uuid -v4)}

PASSWORD=$UUID \
docker run \
--rm \
-p 127.0.0.1:8080:8080 \
-w /home/coder \
-v ${HOME}/code:/home/coder/code:Z \
-v ${HOME}/.bw/:/home/coder/.bw/:Z \
-v ${HOME}/.local/share/code-server:/home/coder/.local/share/code-server:Z \
-v ${HOME}/Library/Application\ Support/Code/User/keybindings.json:/home/coder/.local/share/code-server/User/keybindings.json:Z \
-v ${HOME}/Library/Application\ Support/Code/User/settings.json:/home/coder/.local/share/code-server/User/settings.json:Z \
-e PASSWORD \
-e TZ=America/Detroit \
-e PASSWORD \
ghcr.io/charlesthomas/dev-box:${VERSION} \
&> >> /tmp/code-server.log &

echo $UUID
