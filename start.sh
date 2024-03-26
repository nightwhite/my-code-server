#!/bin/zsh

# 安装全局 Node.js 命令
npm install -g pnpm --registry=https://registry.npmmirror.com
npm install -g laf-cli --registry=https://registry.npmmirror.com

# 安装中文语言包
code-server --install-extension ms-ceintl.vscode-language-pack-zh-hans

code-server

