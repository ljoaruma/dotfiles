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

