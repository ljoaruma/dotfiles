# dotfilesセットアップ

## WSL1/2(Ubuntu)

### proxy環境下の場合

#### 環境変数

``` bash
vim ~/.bashrc
```

``` .bashrc
# 末尾に追加
export http_proxy=http://xxx.xxx.xxx.xxx:xxxxx
export HTTP_PROXY=${http_proxy}
export https_proxy=http://xxx.xxx.xxx.xxx:xxxxx
export HTTPS_PROXY=${https_proxy}
```

#### apt

``` bash
EDITOR=vim sudoedit /etc/apt/apt.conf
```

``` /etc/apt/apt.conf
Acquire::http::Proxy "http://xxx.xxx.xxx.xxx:xxxx";
Acquire::https::Proxy "http://xxx.xxx.xxx.xxx:xxxx";
```

#### github接続設定

``` bash
sudo apt install connect-proxy
vim ~/.ssh/config
```

``` ~/.ssh/config
Host github.com
    User git
    HostName ssh.github.com
    Port 443
    ProxyCommand  connect -H xxx.xxx.xxx.xxx:xxxxx %h %p
    IdentityFile ~/.ssh/id_ed25519
```

## 共通手順

1. 日本語パッケージをインストールして、一度再起動

``` bash
sudo apt -y install language-pack-ja && sudo update-locale LANG=ja_JP.UTF8 && sudo apt -y install manpages-ja manpages-ja-dev
```

2. profile内で行っているサービス起動をパスワード要求なしで起動するようsudoersを変更

``` bash
sudo EDITOR=vim visudo
```

``` /etc/sudoers
%sudo   ALL=NOPASSWD:/usr/sbin/service anacron start *
%sudo   ALL=NOPASSWD:/usr/sbin/service anacron stop *
%sudo   ALL=NOPASSWD:/usr/sbin/service ssh restart*
%sudo   ALL=NOPASSWD:/usr/sbin/service rsyslog restart*
%sudo   ALL=NOPASSWD:/usr/sbin/service cron restart*
```

その他必要パッケージインストール

``` bash
sudo apt install build-essential
sudo apt install -y apt-file mlocate
```

build-essentialの提案パッケージのうち必要そうなものをピックアップ
ドキュメント系は、自動でインストールしたとものしてマークする

``` bash
sudo apt install -y binutils-doc cpp-doc g++-multilib autoconf automake libtool flex bison gdb gcc-doc glibc-doc make-doc libstdc++-9-doc
sudo apt-mark auto libstdc++-9-doc binutils-doc cpp-doc g++-multilib gcc-doc glibc-doc make-doc
```

### 設定ファイルリポジトリダウンロードと設定

``` bash
git clone --branch=dev/slimming-down git@github.com:ljoaruma/dotfiles.git .dotfiles
cd .dotfiles
./setup.bash
```

vim,gitの最新を取得&ビルド, xenv系をインストールして、各スクリプトをバージョン管理する


### vim

必要なライブラリのインストールとセットアップ

```bash
sudo apt -y install libpython3-dev ruby-dev libncurses-dev gettext
bash ~/.dotfiles/vim/setup-vim.sh
cd ~/usr/src/vim
```

ソースの確認等して、以下
```bash
cd ~/usr/src/vim
bash ~/.dotfiles/vim/configure-vim.sh
make && make install
```

### git

### xenv

各バージョン管理モジュールは、~/usr/opt 以下にインストールする(HOMEフォルダ直下のフォルダを増やしたくない)

#### pythonのnenvインストール

候補

- pyenv -> python/pipのバージョン管理に採用
- venv  -> プロジェクトごとのバージョン管理に採用(pythonの標準モジュール)
- pyvenv
- virtualenv

[pyenv](https://github.com/pyenv/pyenv) install 手順( [参考](https://github.com/pyenv/pyenv#basic-github-checkout) )

``` bash
mkdir -v $HOME/usr/opt/ && cd &_
git clone https://github.com/pyenv/pyenv.git $HOME/usr/opt/pyenv
cd $HOME/usr/opt/pyenv && src/configure && make -C src

# the sed invocation inserts the lines at the start of the file
# after any initial comment lines
sed -Ei -e '/^([^#]|$)/ {a \
export PYENV_ROOT="$HOME/usr/opt/pyenv
a \
export PATH="$PYENV_ROOT/bin:$PATH"
a \
' -e ':a' -e '$!{n;ba};}' ~/.profile
echo 'eval "$(pyenv init --path)"' >>~/.profile

echo 'eval "$(pyenv init -)"' >> ~/.bashrc
```

example

``` bash
pyenv install --list   # インスト-ルするバージョンを選択
pyenv install xx.xx.xx # インストール
pyenv rehash
pyenv local|global xx.xx.xx
```

#### rubyのnenvインストール

候補

- rbenv+ruby-build -> 採用
- rvm
  - cd等の組み込みコマンドを関数に差し替えるなどの動作が重たい

[rbenv](https://github.com/rbenv/rbenv) の インストール手順( [参考](https://github.com/rbenv/rbenv#basic-github-checkout) )

``` bash
export RBENV_ROOT="$HOME/usr/opt/rbenv"
git clone https://github.com/rbenv/rbenv.git "$RBENV_ROOT" && cd $_ && src/configure && make -C src
echo 'export RBENV_ROOT="$HOME/usr/opt/rbenv"' >> ~/.bashrc
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bashrc
${RBENV_ROOT}/bin/rbenv init
```

最後のrbenv initの出力に従って、bashrcを変更する。

[ruby-build](https://github.com/rbenv/ruby-build#readme) の インストール手順( [参考](https://github.com/rbenv/ruby-build#installation) )

TODO

#### nodeのnenvインストール

候補

- volta -> 採用 google trend(2022年)で決めた
- n
- nvm  -> rvmと同様、cdなどの組み込みコマンドを関数に差し替えるなどのトリックが必要になる
- nodeenv
- nodebrew -> メンテナンスの頻度が落ちている
- fnm
- asdf

[volta](https://github.com/volta-cli/volta) の インストール手順( [参考](https://docs.volta.sh/guide/getting-started) )

環境変数 VOLTA\_HOME にインストール場所を設定した後、上記インストール手順を実施

TODO

#### rust

TODO

  cargo


#### go

標準機能を使うか、goenvを使うか

go





