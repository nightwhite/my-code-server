FROM codercom/code-server:latest

SHELL ["/bin/bash", "-c"]

USER root

# Install linux apps
RUN apt-get update \
 && apt-get install -y \
    vim \
    curl \
    git

# Install Zsh and Oh My Zsh
RUN curl -o- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  && sed -i "s/plugins=(git.*)$/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/" /root/.zshrc

# Set Zsh as the default shell
SHELL ["/bin/zsh", "-c"]

# Install VSCode extensions
RUN HOME=/root code-server \
    --user-data-dir=/root/.local/share/code-server \
    --install-extension equinusocio.vsc-material-theme \
    --install-extension k--kato.intellij-idea-keybindings \
    --install-extension eamodio.gitlens \
    --install-extension tabnine.tabnine-vscode \
    --install-extension vscjava.vscode-java-pack

# Copy VSCode settings
COPY --chown=root:root settings.json /root/.local/share/code-server/User/settings.json

# Create a volume for projects
RUN mkdir /root/project

# Install NVM and Node.js 18
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && mkdir -p /root/.nvm \
    && echo 'source /root/.nvm/nvm.sh' >> /root/.zshrc \
    && . /root/.nvm/nvm.sh \
    && nvm install 18 \
    && nvm alias default 18 \
    && nvm use default

CMD ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080", "."]
