FROM codercom/code-server:latest

SHELL ["/bin/bash", "-c"]

USER coder

# project volume
RUN mkdir /home/coder/project

# ssh config
RUN mkdir -p /home/coder/.ssh
COPY --chown=coder:coder ./ssh/config /home/coder/.ssh/config
RUN ln -s /run/secrets/host_ssh_key ~/.ssh/id_rsa



# git config
RUN git config --global --add pull.rebase false \
    && git config --global --add user.name beimengyeyu \
    && git config --global --add user.email me@beimengyeyu.com \
    && git config --global core.editor vim \
    && git config --global init.defaultBranch master \
    &&  git config --global alias.pullall '!git pull && git submodule update --init --recursive'

# node env
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh >> /home/coder/install_nvm.sh \
    && . /home/coder/install_nvm.sh \
    && rm -rf /home/coder/install_nvm.sh

ENV NODE_VERSION 14.18.0

RUN source ~/.nvm/nvm.sh \
    && nvm install $NODE_VERSION \
    $$ nvm alias default $NODE_VERSION \
    && nvm use default

# zsh
RUN curl -o- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh >> ~/oh_my_zsh.sh \
  && echo 'y' | . ~/oh_my_zsh.sh \
  && rm -rf  ~/oh_my_zsh.sh \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  && sed -i "s/plugins=(git.*)$/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/" ~/.zshrc 

# linux app
RUN sudo apt-get update \
 && sudo apt-get install -y \
    vim

 # default bash
RUN echo "dash dash/sh boolean false" | sudo debconf-set-selections
RUN sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash   

# vscode plugin
RUN HOME=/home/coder code-server \
	--user-data-dir=/home/coder/.local/share/code-server \
	--install-extension equinusocio.vsc-material-theme \
  --install-extension k--kato.intellij-idea-keybindings \
  --install-extension eamodio.gitlens \
  --install-extension tabnine.tabnine-vscode 

COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/settings.json