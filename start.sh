#!/bin/bash

# 安装中文语言包
code-server --install-extension ms-ceintl.vscode-language-pack-zh-hans

# 安装全局 Node.js 命令
npm install -g pnpm --registry=https://registry.npmmirror.com
npm install -g laf-cli --registry=https://registry.npmmirror.com

# 启动 Code Server
code-server
