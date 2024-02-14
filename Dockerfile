ARG UPSTREAM_VERSION=4.21.1
FROM codercom/code-server:${UPSTREAM_VERSION}

RUN sudo apt-get update \
 && sudo apt-get install --no-install-recommends --yes \
    bat \
    fzf \
    golang-go \
    jq \
    kubecolor \
    kubectx \
    kubernetes-client \
    python3 \
    python3-poetry \
    python-is-python3 \
    pipx \
    ripgrep \
    stow \
    yq \
 && sudo apt-get clean

# gh
RUN sudo curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list \
 && sudo apt-get update \
 && sudo apt-get install --no-install-recommends --yes gh \
 && sudo apt-get clean

# helm
RUN sudo apt-get install --no-install-recommends --yes apt-transport-https gpg \
 && curl https://baltocdn.com/helm/signing.asc \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/helm.gpg > /dev/null \
 && sudo apt-get install apt-transport-https --yes \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" \
  | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list \
 && sudo apt-get update \
 && sudo apt-get install --no-install-recommends --yes helm \
 && sudo apt-get clean
