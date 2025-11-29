#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

declare -r VIM_RUNTIME_PATH="${XDG_DATA_HOME:-${HOME}/.local/share}/vim.runtime"
declare -r VIM_RUNTIME_PATH_WIN="${HOME}/vimfiles"
mkdir -vp ${VIM_RUNTIME_PATH}

if [[ -v OS ]] && [[ "${OS}" = *Windows* ]]; then
  declare -r SOLALIZE_INSTALLPATH=$HOME/vim-plug-ins
else
  declare -r SOLALIZE_INSTALLPATH="${VIM_RUNTIME_PATH}/pack/themes/opt"
fi

mkdir -vp "${SOLALIZE_INSTALLPATH}"
cd "${SOLALIZE_INSTALLPATH}"
git clone https://github.com/lifepillar/vim-solarized8.git

exit

# 以下は昔のsolarized記録のため残しておく
# 古いsolarizedはTrue Color環境に対応しておらず、True Color環境での動作不正が発生するので利用できなくなった。
# AIによる回答
# 現在の問題は、古い solarized.vim が set termguicolors を使っているときに、Vimの背景色をTerminalの背景色で上書きする 処理が正しく行われないために発生しています。その結果、Vimはテーマの色（文字色など）をTrue Colorで出力していますが、背景にはWindows Terminalの「Ubuntuプロファイルの色」（濃い紫/黒）が透けて見えている状態です。

#mkdir -vp "${SOLALIZE_INSTALLPATH}"
#cd "${SOLALIZE_INSTALLPATH}"
#git clone https://github.com/altercation/solarized.git
#
## to vim
#
#cp -vprl -t "${VIM_RUNTIME_PATH}" solarized/vim-colors-solarized/*
#
## to vim(win)
#
#if [[ -v OS ]] && [[ "${OS}" = *Windows* ]]; then
#  cp -vprl -t "${VIM_RUNTIME_PATH_WIN}" solarized/vim-colors-solarized/*
#fi

