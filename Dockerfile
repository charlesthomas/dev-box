ARG UPSTREAM_VERSION=4.20.1
FROM codercom/code-server:${UPSTREAM_VERSION}

RUN sudo curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list #> /dev/null

RUN sudo apt-get update \
 && sudo apt-get install -y \
    golang-go \
    python3 \
    python-is-python3 \
    python3-poetry \
    pipx \
    yq \
    jq \
    kubernetes-client \
    kubectx \
    kubecolor \
    ripgrep \
    bat \
    fzf \
    gh
