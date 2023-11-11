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

# Install NVM and Node.js 18
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && chmod +x /home/startup.sh \
    && . /home/startup.sh \
    && . /home/coder/.nvm/nvm.sh \
    && nvm install 18 \
    && nvm alias default 18 \
    && nvm use default
    && echo '#!/bin/bash' >> /home/startup.sh \
    && echo 'if [ ! -d "/home/coder/.nvm" ]; then' >> /home/startup.sh \
    && echo '  cp -r /home/tmp/* /home/coder/' >> /home/startup.sh \
    && echo 'fi' >> /home/startup.sh \

# Create a volume for projects
RUN mkdir /home/coder/project

# Set startup script as CMD
CMD ["/home/startup.sh"]
