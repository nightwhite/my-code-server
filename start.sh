#!/bin/bash

# 安装中文语言包
code-server --install-extension ms-ceintl.vscode-language-pack-zh-hans

# Load NVM
export NVM_DIR="/home/coder/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Use a specific version of Node
nvm use 18

# Now you can use npm
npm --version  # 检查 npm 版本

# 安装全局 Node.js 命令
npm install -g pnpm --registry=https://registry.npmmirror.com
npm install -g laf-cli --registry=https://registry.npmmirror.com

# 启动 Code Server
code-server
