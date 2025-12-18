#!/bin/bash
# vim: set expandtab ts=2 fenc=utf-8 ff=unix filetype=sh :

# エラー発生時は即中断
set -eu -o pipefail

# prepared
# ===

## my .profile to conf directory
readonly MY_DOT_PROFILE_ROOT_DIRECTORY_="$(cd $(dirname ${BASH_SOURCE:-$0})/.. && pwd -P)"
readonly MY_DOT_PROFILE_CONFIG_DIRECTORY_="${MY_DOT_PROFILE_ROOT_DIRECTORY_}/config"
readonly MY_DOT_PROFILE_PATH_="${MY_DOT_PROFILE_CONFIG_DIRECTORY_}/profile"

. "${MY_DOT_PROFILE_PATH_}"

readonly PLACED_DOTFILE_DIRECTORY_="${XDG_CONFIG_HOME}/profile"
readonly PLACED_DOTFILE_PATH_="${PLACED_DOTFILE_DIRECTORY_}/profile"

# Create XDB Base Directory
# ===

mkdir -vp "${XDG_CONFIG_HOME}"
mkdir -vp "${XDG_CACHE_HOME}"
mkdir -vp "${XDG_DATA_HOME}"
mkdir -vp "${XDG_STATE_HOME}"

mkdir -vp ${HOME}/.local/{src,bin,lib,include,sbin,share,opt}
#mkdir -vp ${HOME}/.local/{src,bin,lib,include,sbin,share,opt}
#mkdir -vp ${HOME}/.local/share/{src,bin,lib,include,sbin,share,opt}
#mkdir -vp ${HOME}/.local/usr/{src,bin,lib,include,sbin,share,opt}

# setup profile source 
# ===

if [ -L "${PLACED_DOTFILE_DIRECTORY_}" ]; then
  unlink "${PLACED_DOTFILE_DIRECTORY_}"
fi
if [ -e "${PLACED_DOTFILE_DIRECTORY_}" ]; then
  echo "exist ${PLACED_DOTFILE_DIRECTORY_}"
  exit 0
fi

ln -s "${MY_DOT_PROFILE_CONFIG_DIRECTORY_}" "${PLACED_DOTFILE_DIRECTORY_}"

## .profile add source .profile function 

### source .profile function

#### my .profile path replace /home/username -> ${HOME}
readonly PLACED_DOTFILE_PATH_UNEXPAND_="${PLACED_DOTFILE_PATH_/#${HOME}/\$\{HOME\}}"
if grep -q -F -e "${PLACED_DOTFILE_PATH_UNEXPAND_}" ~/.profile; then # grepオプション -F は固定文字列での検索を指定
  # すでに.profileにカスタムprofileがある場合はセットアップ済みとして終了
  echo ".profile already setup(added source function)"
  exit 0
fi

#### original .profile backup
readonly PLACED_DEFAULT_DOT_PROFILE_="${PLACED_DOTFILE_DIRECTORY_}/profile.default"
# default profile path replace /home/username -> ${HOME}
readonly PLACED_DEFAULT_DOT_PROFILE_UNEXPAND_="${PLACED_DEFAULT_DOT_PROFILE_/#${HOME}/\$\{HOME\}}"

if [ -f $HOME/.profile ]; then

  readonly STORED_CONF_DIRECTORY_="${XDG_DATA_HOME}/dotfiles/stored/profile"
  if [ -f  "${STORED_CONF_DIRECTORY_}/.profile" ]; then
    # すでに退避済みのファイルがある場合はセットアップ済みとして終了
    echo ".profile already setup(stored)"
    exit 0
  fi

  mkdir -vp "${STORED_CONF_DIRECTORY_}"
  cp --backup=t -vpL $HOME/.profile "${STORED_CONF_DIRECTORY_}"
  mv -i $HOME/.profile "${PLACED_DEFAULT_DOT_PROFILE_}"

fi

#### source function
#### ---
#### 先頭にカスタム.profileのsource、既存の.profile, 最後に改行を追加
#### bashrc読み込み前にカスタム.profileを読むこむため先頭にsourceを追加する

readonly INSERT_PROFILE_COMMAND_="$(
cat - <<EOL

# source by my profile
if [ -f "${PLACED_DOTFILE_PATH_UNEXPAND_}" ]; then
  . "${PLACED_DOTFILE_PATH_UNEXPAND_}"
fi

# source by default profile
if [ -f "${PLACED_DEFAULT_DOT_PROFILE_UNEXPAND_}" ]; then
  . "${PLACED_DEFAULT_DOT_PROFILE_UNEXPAND_}"
fi


EOL
)"

### add function
### ---

#echo "${INSERT_PROFILE_COMMAND_}" > $HOME/.profile
rm -f $HOME/.profile
ln -s "${MY_DOT_PROFILE_CONFIG_DIRECTORY_}/root_profile" $HOME/.profile

###

# disable login message
touch /home/ryo/.hushlogin

