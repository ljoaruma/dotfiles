#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

SCRIPT_DIRECTORY="$(cd $(dirname "${BASH_SOURCE:-$0}") && pwd -P)"

# [ビルド手順](https://vim-jp.org/docs/build_linux.html]
# [src-dep有効化手順](https://zenn.dev/mtkn1/articles/ubuntu-noble-repository-source)

## 関連パッケージのインストール

# src-dep有効化
sudo apt-get update \
    && sudo DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install python3-software-properties \
    && sudo /usr/bin/python3 -c "from softwareproperties.SoftwareProperties import SoftwareProperties; SoftwareProperties(deb822=True).enable_source_code_sources()" \
    && sudo apt-get update

sudo apt build-dep vim
# with-luajitの場合必要
sudo apt install luajit2 libluajit2-5.1-dev

## リポジトリクローン(最新タグをチェックアウト)

readonly VIM_SOURCE_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/src"

if [ ! -d "${VIM_SOURCE_DIR}" ]; then
  mkdir -vp "${VIM_SOURCE_DIR}"
fi

cd "${VIM_SOURCE_DIR}"

if [ ! -d "${VIM_SOURCE_DIR}/vim" ]; then
  git clone https://github.com/vim/vim.git
fi

cd "${VIM_SOURCE_DIR}/vim"
git fetch origin

export TARGET_TAG="$(git describe --tags origin/HEAD)"
echo "install version ${TARGET_TAG} OK?(press any key)"
read

git switch --detach "${TARGET_TAG}"

## configure & make & install

"${SCRIPT_DIRECTORY}"/vim-configure.sh &&
  make clean && make -j $( expr $(cat /proc/cpuinfo | grep processor | wc -l) / 2 + 1) && make install || { echo "failed vim imstall"; exit 1; }

