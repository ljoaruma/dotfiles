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

#### pythonのxenvインストール

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

Upgrade

``` bash
cd $(pyenv root)
git pull
# or
git fetch
git tag
git switch vxx.x.xx
```

##### mac os, python 3.7.13, 3.8.13, 3.9.11 and 3.10.3 build

[参照リンク1](https://github.com/pyenv/pyenv/issues/2143)
[参照リンク2](https://github.com/pyenv/pyenv/issues/2143#issuecomment-1069269496)
[参照リンク3](https://github.com/pyenv/pyenv/issues/2143#issuecomment-1069723477)

```
configure: error: internal configure error for the platform triplet, please file a bug report
make: *** No targets specified and no makefile found.  Stop.
```

Mac において上記エラーメッセージでインストールに失敗する場合、以下のパッチファイルを***.patchファイルとして保存して、インストール時に適用する。コマンドは``` cat foo.patch | pyenv install -p x.xx.xx ```

* pyenv installの-pオプションはビルド前にstdinからのパッチを適用する

``` diff
diff --git configure configure
index e39c16eee2..2455870bf8 100755
--- configure
+++ configure
@@ -5202,10 +5202,6 @@ $as_echo "$as_me:
   " >&6;}
 fi

-
-MULTIARCH=$($CC --print-multiarch 2>/dev/null)
-
-
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for the platform triplet based on compiler characteristics" >&5
 $as_echo_n "checking for the platform triplet based on compiler characteristics... " >&6; }
 cat >> conftest.c <<EOF
@@ -5334,6 +5330,10 @@ $as_echo "none" >&6; }
 fi
 rm -f conftest.c conftest.out

+if test x$PLATFORM_TRIPLET != xdarwin; then
+  MULTIARCH=$($CC --print-multiarch 2>/dev/null)
+fi
+
 if test x$PLATFORM_TRIPLET != x && test x$MULTIARCH != x; then
   if test x$PLATFORM_TRIPLET != x$MULTIARCH; then
     as_fn_error $? "internal configure error for the platform triplet, please file a bug report" "$LINENO" 5
@@ -9230,6 +9230,9 @@ fi
     	ppc)
     		MACOSX_DEFAULT_ARCH="ppc64"
     		;;
+    	arm64)
+    		MACOSX_DEFAULT_ARCH="arm64"
+    		;;
     	*)
     		as_fn_error $? "Unexpected output of 'arch' on OSX" "$LINENO" 5
     		;;
```

#### rubyのxenvインストール

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

``` bash
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
```

[ruby-gemset](https://github.com/jf/rbenv-gemset) の インストール手順( [参考](https://github.com/jf/rbenv-gemset#installation) )

``` bash
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/jf/rbenv-gemset.git "$(rbenv root)"/plugins/rbenv-gemset
```

#### nodeのxenvインストール

候補

- volta -> 採用 google trend(2022年)で決めた
- n
- nvm  -> rvmと同様、cdなどの組み込みコマンドを関数に差し替えるなどのトリックが必要になる
- nodeenv
- nodebrew -> メンテナンスの頻度が落ちている
- fnm
- asdf

[volta](https://github.com/volta-cli/volta) の インストール手順( [参考](https://docs.volta.sh/guide/getting-started) )

``` bash
export VOLTA_HOME=$HOME/usr/opt/volta
mkdir -vp "${VOLTA_HOME}"
curl https://get.volta.sh | bash
# 再ログインして、voltaまでのPATHがとっている状態であることを確認したらlatestバージョンのツールセットが利用できる状態にしておく
volta install node@latest
volta install npm@latest
volta intsall yarn@latest
```

#### rust

CARGO_HOME と RUSTUP_HOM の環境変数がインストール先を制御

```bash
export RUSTUP_HOME=$HOME/usr/opt/rustup
export CARGO_HOME=$HOME/usr/opt/cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
vim ~/.bashrc
export RUSTUP_HOME=$HOME/usr/opt/rustup
export CARGO_HOME=$HOME/usr/opt/cargo
source "$CART_HOME/env"
```

#### go

標準機能を使うか、goenvを使うか

go
