FROM codercom/code-server:latest

SHELL ["/bin/bash", "-c"]

USER coder

# Install linux apps
RUN sudo apt-get update \
 && sudo apt-get install -y \
    vim \
    curl \
    git

# Install NVM and Node.js 18
ENV NVM_DIR /home/coder/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install 18 \
    && nvm alias default 18 \
    && nvm use default

# Install Java
RUN sudo apt install -y openjdk-11-jdk \
    openjdk-17-jdk

# Install Zsh and Oh My Zsh
RUN curl -o- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  && sed -i "s/plugins=(git.*)$/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/" ~/.zshrc

# Set Zsh as the default shell
SHELL ["/bin/zsh", "-c"]

# Configure Git
RUN git config --global --add pull.rebase false \
    && git config --global --add user.name beimengyeyu \
    && git config --global --add user.email me@beimengyeyu.com \
    && git config --global core.editor vim \
    && git config --global init.defaultBranch master \
    && git config --global alias.pullall '!git pull && git submodule update --init --recursive'

# Install VSCode extensions
RUN HOME=/home/coder code-server \
	--user-data-dir=/home/coder/.local/share/code-server \
	--install-extension equinusocio.vsc-material-theme \
    --install-extension k--kato.intellij-idea-keybindings \
    --install-extension eamodio.gitlens \
    --install-extension tabnine.tabnine-vscode \
    --install-extension vscjava.vscode-java-pack

# Copy VSCode settings
COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/settings.json

# Create a volume for projects
RUN mkdir /home/coder/project
