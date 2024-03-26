FROM codercom/code-server:latest

SHELL ["/bin/bash", "-c"]

USER coder

# Install linux apps
RUN sudo apt-get update \
 && sudo apt-get install -y \
    vim \
    curl \
    git

# Install Zsh and Oh My Zsh
RUN curl -o- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  && sed -i "s/plugins=(git.*)$/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/" ~/.zshrc

# Set Zsh as the default shell
SHELL ["/bin/zsh", "-c"]

# Copy the VSCode extensions laf-assistant
COPY NightWhite.laf-assistant-1.0.14.vsix /home/coder/NightWhite.laf-assistant-1.0.14.vsix

# Install VSCode extensions
RUN HOME=/home/coder code-server \
    --user-data-dir=/home/coder/.local/share/code-server \
    --install-extension ms-ceintl.vscode-language-pack-zh-hans \
    --install-extension /home/coder/NightWhite.laf-assistant-1.0.14.vsix

# Copy VSCode settings
COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/settings.json

# Install NVM and Node.js 18
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && echo 'source /home/coder/.nvm/nvm.sh' >> /home/coder/.bashrc \
    && echo 'source /home/coder/.nvm/nvm.sh' >> /home/coder/.zshrc \
    && . /home/coder/.nvm/nvm.sh \
    && nvm install 18 \
    && nvm alias default 18 \
    && nvm use default
    && node install -g laf-cli@latest
