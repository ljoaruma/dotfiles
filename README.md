# ドットファイルセットアップ
---

## 概要

必要なドットファイルのセットアップを行う

## 利用方法

``` bash
mkdir -vp "${XDG_CONFIG_HOME:-$HOME/.config}"
cd "${XDG_CONFIG_HOME:-$HOME/.config}"
git clone git@github.com:ljoaruma/dotfiles.git 
setup.bash
```

ソースビルドするパッケージは `[パッケージ名]/setup/[パッケージ名]-install.sh` を実行する。
ビルドに関する情報は[INSTALLATION](INSTALLATION.md)参照

## 構造の説明

おおよそ以下のディレクトリ構造でファイルを配置

``` txt
├── INSTALLATION.md
├── README.md
├── setup.bash
├── [module or package] # per module or package directory
│   ├── config
│   │   ├── [module or pakcage config file]
│   │   └── switches # function switch
│   │       ├── catalog # switch catalog
│   │       │   ├── [switch file sample]
│   │       └── enable # switch enable directory
│   │           └── [enlable switch file]
│   ├── setup
│   │   ├── [module]-setup.sh
│   │   ├── [module]-install.sh
│   ├── share # data directory
│   ├── [other files ]
│   └── ...
...
```

モジュールごとの設定ファイルをconfig以下に格納。setupスクリプトがconfigなどの配置等モジュールの必要な設定を行う。installスクリプトはモジュールのソースビルド等を行う。

## インストール先

XDG Base Directoryに従う
* [Arch Linux Wiki](https://wiki.archlinux.jp/index.php/XDG_Base_Directory)
* [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/)

配置の基本方針

---
* dotfiles -> XDG\_CONFIG\_HOME/dotfiles
* 各設定 -> XDG\_CONFIG\_HOME/[アプリ名]
---
* ソースビルドのソース配置場所 -> XDG\_DATA\_HOME/src/[アプリ名]
* ソースビルドのPREFIX -> $HOME/.local
* ソースビルドのPREFIX(別途パスを通すパッケージのみのディレクトリに格納する場合) -> $HOME/.local/opt/[アプリ名]
---
* ログ等 -> $XDG\_STATE\_HOME/[アプリ名]
---
* dotfilesで上書きする設定ファイルのバックアップ先 -> $XDG\_DATA\_HOME/dotfiles/stored/[アプリ名]

## 開発

テスト用のDockerファイルを配置しているので、以下のいずれかで利用

### docker compose
```bash:test.sh
docker compose -f .devcontainer/base-arch/docker-compose.yaml run -rm base-arch/Dockerfile.test
docker compose -f .devcontainer/base-ubuntu/docker-compose.yaml run -rm base-ubuntu/Dockerfile.test /bin/bash
```

### VSCode devcontainer

1. `ctrl + shift + p`で`Dev Containers: Reopen in Container`
2. クリーンな状態で再度コンテナを動かす場合は`ctrl + shift + p`で`Dev Containers: Rebuild and Reopen in Container`

