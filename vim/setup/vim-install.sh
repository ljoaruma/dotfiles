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

if [ ! -d $HOME/.local/src ]; then
  mkdir -vp $HOME/.local/src
fi

cd $HOME/.local/src

if [ ! -d $HOME/.local/src/vim ]; then
  git clone https://github.com/vim/vim.git
fi

cd $HOME/.local/src/vim
git fetch origin

export TARGET_TAG="$(git describe --tags origin/HEAD)"
echo "install version ${TARGET_TAG} OK?"
read

git switch --detach "${TARGET_TAG}"

## configure

"${SCRIPT_DIRECTORY}"/vim-configure.sh &&
make clean && make && make install || { echo "failed vim imstall"; exit 1; }

