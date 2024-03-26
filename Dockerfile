FROM codercom/code-server:latest

SHELL ["/bin/bash", "-c"]

USER coder
# Install Linux apps
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

# Copy the VSCode extension laf-assistant zh
COPY MS-CEINTL.vscode-language-pack-zh-hans-1.87.0.vsix /home/MS-CEINTL.vscode-language-pack-zh-hans-1.87.0.vsix
COPY NightWhite.laf-assistant-1.0.14.vsix /home/NightWhite.laf-assistant-1.0.14.vsix

# Install VSCode extensions
RUN HOME=/home/coder code-server \
    --user-data-dir=/home/coder/.local/share/code-server \
    --install-extension /home/NightWhite.laf-assistant-1.0.14.vsix

# Copy VSCode settings
COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/settings.json
COPY --chown=coder:coder argv.json /home/coder/.local/share/code-server/User/argv.json

# Install NVM, Node.js 18, and set custom npm directory
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && echo 'export NVM_DIR="$HOME/.nvm"' >> /home/coder/.zshrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/coder/.zshrc \
    && echo 'export PATH="$NVM_DIR/versions/node/$(nvm current)/bin:$PATH"' >> /home/coder/.zshrc \
    && . /home/coder/.nvm/nvm.sh \
    && nvm install 18 \
    && nvm alias default 18 \
    && nvm use default \
    && mkdir /home/coder/npm-global \
    && npm config set prefix '/home/coder/npm-global' \
    && echo 'export PATH="/home/coder/npm-global/bin:$PATH"' >> /home/coder/.zshrc 

ENV PATH="/home/coder/npm-global/bin:${PATH}"
