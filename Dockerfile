ARG BW_VERSION
ARG CODE_SERVER_VERSION

FROM ghcr.io/charlesthomas/bitwarden-cli:${BW_VERSION} AS bw

FROM codercom/code-server:${CODE_SERVER_VERSION}

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
COPY --from=bw /usr/local/bin/bw /usr/local/bin/

# go
ARG GO_VERSION
RUN curl -sLO "https://go.dev/dl/go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz" \
 && sudo tar -C /usr/local -xzf "go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz" \
 && sudo ln -s /usr/local/go/bin/go /usr/local/bin/go \
 && rm "go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz"

# kubectl && helm
ARG KUBECTL_VERSION
RUN curl -sLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETPLATFORM}/kubectl" \
 && mv kubectl /usr/local/bin/ \
 && chmod +x /usr/local/bin/kubectl \
 && curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

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
ARG JB_VERSION
ARG KUBECFG_VERSION
RUN GOPATH=~/.go go install github.com/kubecfg/kubecfg@${KUBECFG_VERSION} \
 && GOPATH=~/.go go install -a github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@${JB_VERSION} \
 && mkdir -p ~/bin \
 && ln -s ~/.go/bin/kubecfg ~/bin/kubecfg \
 && ln -s ~/.go/bin/jb ~/bin/jb
