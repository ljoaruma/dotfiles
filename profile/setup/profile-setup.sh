#!/bin/bash
# vim: set expandtab ts=2 fenc=utf-8 ff=unix filetype=sh :

# Create XDB Base Directory
# ===

mkdir -vp "${XDG_CONFIG_HOME:-${HOME}/.config}"
mkdir -vp "${XDG_CACHE_HOME:-${HOME}/.cache}"
mkdir -vp "${XDG_DATA_HOME:-${HOME}/.local/share}"
mkdir -vp "${XDG_STATE_HOME:-${HOME}/.local/state}"

mkdir -vp ${HOME}/.local/{src,bin,lib,include,sbin,share,opt}
#mkdir -vp ${HOME}/.local/{src,bin,lib,include,sbin,share,opt}
#mkdir -vp ${HOME}/.local/share/{src,bin,lib,include,sbin,share,opt}
#mkdir -vp ${HOME}/.local/usr/{src,bin,lib,include,sbin,share,opt}

# setup profile source 
# ===

## my .profile to conf directory
readonly MY_DOT_PROFILE_DIRECTORY_="$(cd $(dirname ${BASH_SOURCE:-$0})/.. && pwd -P)"
readonly MY_DOT_PROFILE_="${MY_DOT_PROFILE_DIRECTORY_}/config/profile"
readonly MY_DOT_PROFILE_PLACED_="${XDG_CONFIG_HOME:-${HOME}/.config}/profile"
ln -sf "${MY_DOT_PROFILE_}" "${MY_DOT_PROFILE_PLACED_}"

## .profile add source .profile function 

### source .profile function

#### my .profile path replace /home/username -> ${HOME}
readonly MY_DOT_PROFILE_PATH_="${MY_DOT_PROFILE_PLACED_/#${HOME}/\$\{HOME\}}"
if grep -q -F -e "${MY_DOT_PROFILE_PATH_}" ~/.profile; then # grepオプション -F は固定文字列での検索を指定
  # すでに.profileにカスタムprofileがある場合はセットアップ済みとして終了
  echo ".profile already setup(added source function)"
  exit 0
fi
#### source function
readonly INSERT_PROFILE_COMMAND_="$(
cat - <<EOL

# source by my profile
if [ -f "${MY_DOT_PROFILE_PATH_}" ]; then
  . "${MY_DOT_PROFILE_PATH_}"
fi

#


EOL
)"

### original .profile backup
readonly STORED_CONF_DIRECTORY_="${XDG_DATA_HOME:-${HOME}/.local/share}/dotfiles/stored"
if [ -f  "${STORED_CONF_DIRECTORY_}/.profile" ]; then
  # すでに退避済みのファイルがある場合はセットアップ済みとして終了
  echo ".profile already setup(stored)"
  exit 0
fi
mkdir -vp "${STORED_CONF_DIRECTORY_}"
cp --backup=t -vpL $HOME/.profile "${STORED_CONF_DIRECTORY_}"

### add function
### ---
### 先頭にカスタム.profileのsourceを追加して既存の.profile, 最後に改行を追加
### bashrc読み込み前にカスタム.profileを読むこむため先頭にsourceを追加する

echo "${INSERT_PROFILE_COMMAND_}" > $HOME/.profile
echo "" >> $HOME/.profile
cat "${STORED_CONF_DIRECTORY_}/.profile" >> $HOME/.profile
echo "" >> $HOME/.profile

###

# disable login message
touch /home/ryo/.hushlogin

