ARG UPSTREAM_VERSION=4.21.2
FROM codercom/code-server:${UPSTREAM_VERSION}

ARG TARGETARCH
ARG TARGETOS
ARG TARGETPLATFORM

USER root

# apt tools
RUN apt-get update \
 && apt-get install --no-install-suggests --no-install-recommends --yes \
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
RUN apt-get install --no-install-suggests --no-install-recommends --yes build-essential npm \
 && npm install -g @bitwarden/cli \
 && apt-get clean

# go
ARG GO_VERSION=1.22.0
RUN curl -sLO "https://go.dev/dl/go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz" \
 && sudo tar -C /usr/local -xzf "go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz" \
 && sudo ln -s /usr/local/go/bin/go /usr/local/bin/go \
 && rm "go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz"

# kubectl && helm
ARG KUBECTL_VERSION=v1.29.2
RUN curl -sLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETPLATFORM}/kubectl" \
 && mv kubectl /usr/local/bin/ \
 && chmod +x /usr/local/bin/kubectl \
 && curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

USER 1000

RUN curl -sS https://webi.sh/bat | sh \
 && curl -sS https://webi.sh/delta | sh \
 && curl -sS https://webi.sh/gh | sh \
 && curl -sS https://webi.sh/jq | sh \
 && curl -sS https://webi.sh/kubectx | sh \
 && curl -sS https://webi.sh/kubens | sh \
 && curl -sS https://webi.sh/rg | sh \
 && curl -sS https://webi.sh/yq | sh \
 && sudo find ~/.local/opt/ -type f -executable -exec mv {} /usr/local/bin \; \
 && rm -rf ~/.local/

# work
ARG JB_VERSION=v0.5.1
ARG KUBECFG_VERSION=v0.34.3
RUN GOPATH=~/.go go install github.com/kubecfg/kubecfg@${KUBECFG_VERSION} \
 && GOPATH=~/.go go install -a github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@${JB_VERSION} \
 && mkdir -p ~/bin \
 && ln -s ~/.go/bin/kubecfg ~/bin/kubecfg \
 && ln -s ~/.go/bin/jb ~/bin/jb
