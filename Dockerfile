ARG UPSTREAM_VERSION=4.21.1
FROM codercom/code-server:${UPSTREAM_VERSION}

ARG TARGETPLATFORM

USER root

# apt tools
RUN apt-get update \
 && apt-get install --no-install-recommends --yes \
    fzf \
    jsonnet \
    make \
    parallel \
    pipx \
    python-is-python3 \
    python3 \
    python3-poetry \
    stow \
    vim \
 && apt-get clean

# bw
ARG BW_VERSION=2024.2.0
RUN apt-get install --no-install-recommends --yes unzip \
 && curl -sLO https://github.com/bitwarden/clients/releases/download/cli-v${BW_VERSION}/bw-linux-${BW_VERSION}.zip \
 && unzip bw-linux-${BW_VERSION}.zip \
 && chmod +x bw \
 && mv bw /usr/local/bin/bw \
 && rm -rfv *.zip


# kubectl && helm
ARG KUBECTL_VERSION=v1.29.2
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/${TARGETPLATFORM}/kubectl" \
 && mv kubectl /usr/local/bin/ \
 && curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

ARG USER=crthomas
RUN useradd -m ${USER} -s /bin/bash

USER ${USER}

RUN curl -sS https://webi.sh/bat | sh \
 && curl -sS https://webi.sh/delta | sh \
 && curl -sS https://webi.sh/gh | sh \
 && curl -sS https://webi.sh/go | sh \
 && curl -sS https://webi.sh/jq | sh \
 && curl -sS https://webi.sh/kubectx | sh \
 && curl -sS https://webi.sh/kubens | sh \
 && curl -sS https://webi.sh/rg | sh \
 && curl -sS https://webi.sh/yq | sh \
 && ln -s ~/.local/opt/go/bin/go ~/.local/bin/go \
 && rm ~/.bashrc ~/go


# work
ARG JB_VERSION=v0.5.1
ARG KUBECFG_VERSION=v0.34.3
RUN cd /home/${USER} \
 && GOPATH=~/.go ~/.local/opt/go/bin/go install github.com/kubecfg/kubecfg@${KUBECFG_VERSION} \
 && GOPATH=~/.go ~/.local/opt/go/bin/go install -a github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@${JB_VERSION} \
 && mkdir -p ~/bin \
 && ln -s ~/.local/opt/go/bin/kubecfg ~/bin/kubecfg \
 && ln -s ~/.local/opt/go/bin/jb ~/bin/jb
