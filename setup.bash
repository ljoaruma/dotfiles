#!/bin/bash
# vim: set expandtab ts=2 fenc=utf-8 ff=unix filetype=bash :

if [[ ! -v HOME ]]; then
  echo "no environment HOME"
  exit 1
fi

readonly _SETUP_SOURCE="${BASH_SOURCE:-$0}"
readonly _SETUP_SCRIPT_NAME="$(basename "${_SETUP_SOURCE}")"
readonly _SOURCE_DIRECTORY="$(cd "$(dirname "${_SETUP_SOURCE}")" && pwd)"
readonly _BACKUP_DIRECTORY="$(mkdir -vp "${_SOURCE_DIRECTORY}/.beforesetup/$(date "+%Y%m%d-%H%M%S.%N%z")" >&2 && cd $_ && pwd)"

readonly _FULLPATH_SOURCE_DIRECTORY="${_SOURCE_DIRECTORY/#${HOME}/\$\{HOME%/\}}"
echo "${_FULLPATH_SOURCE_DIRECTORY}"

function ProfileSetup() {
  local -r _PROFILE="${HOME}/.profile"
  local -r _INSERT_PROFILE="profile/profile"
  local -r _FULLPATH_PROFILE_SOURCE_DIRECTORY="${_SOURCE_DIRECTORY/#${HOME}/\$\{HOME\}}"

  if [[ ! -e ${_PROFILE} ]]; then
    echo ".profile not found"
    return
  fi

  if grep -q -F -e "${_FULLPATH_PROFILE_SOURCE_DIRECTORY}" "${_PROFILE}"; then
    echo ".profile already setup"
    return
  fi

  local -r _INSERT_PROFILE_COMMAND="$(
cat - <<EOL

# source by my profile
if [ -f "$_FULLPATH_PROFILE_SOURCE_DIRECTORY/$_INSERT_PROFILE" ]; then
  . "$_FULLPATH_PROFILE_SOURCE_DIRECTORY/$_INSERT_PROFILE"
fi
EOL
)"

  cp --backup=t -vpt "${_BACKUP_DIRECTORY}" "${_PROFILE}"

  echo "${_INSERT_PROFILE_COMMAND}" >> "${_PROFILE}"
  # 末尾に改行のみの行追加
  echo >> "${_PROFILE}"

}

function BashrcSetup() {
  local -r _BASHRC="${HOME}/.bashrc"
  local -r _INSERT_BASHRC=bash/bashrc

  if [[ ! -e "${_SETUP_SOURCE}" ]]; then
    echo "not found ${_SETUP_SOURCE}"
    return 1
  fi

  if [[ ! -d "${_SOURCE_DIRECTORY}" ]]; then
    echo "not found ${_SOURCE_DIRECTORY}"
    return 1
  fi

  local -r _INSERT_SOURCE_COMMAND=$(cat <<EOL

if [[ -f "${_FULLPATH_SOURCE_DIRECTORY}/${_INSERT_BASHRC}" ]]: then
  source "${_FULLPATH_SOURCE_DIRECTORY}/${_INSERT_BASHRC}"
fi
EOL
  )

  if [[ ! -f "${_BASHRC}" ]]; then
    touch "${_BASHRC}" && \
    chmod 644 "${_BASHRC}" && \
    echo "${_INSERT_SOURCE_COMMAND}" >> "${_BASHRC}"

    return 0
  fi

  if grep -q -F "${_FULLPATH_SOURCE_DIRECTORY}" "${_BASHRC}" &> /dev/null; then
    echo "bashrc already setup"

    return 0
  fi

  cp --backup=t -vpt "${_BACKUP_DIRECTORY}" "${_BASHRC}"

# HISTFILESIZEが設定されると履歴ファイルが切り詰められるのでそこだけ元のファイルからコメントアウト
  sed \
    -e 's/^[[:blank:]]*\(export[[:blank:]]\+\)\?HISTFILESIZE=[0-9]\+[[:blank:]]*\(.*\)*$/#\0/g' \
    -e 's/^\([[:blank:]]*[^#].*\)\<export[[:blank:]]\+HISTFILESIZE=[0-9]*\([^0-9].*\)\?$/\1:\2/g' \
    -e 's/^\([[:blank:]]*[^#].*\)\<HISTFILESIZE=[0-9]*\([^0-9].*\)\?$/\1:\2/g' \
    "${_BASHRC_ORG}" > \
    "${_BASHRC}"

  echo "${_INSERT_SOURCE_COMMAND}" >> "${_BASHRC}"
  # 末尾に改行のみの行追加
  echo >> "${_BASHRC}"

}

function TmuxConfSetup() {
  local -r _TMUX_CONF="${HOME}/.tmux.conf"
  local -r _INSERT_TMUX_CONF="${_SOURCE_DIRECTORY}/tmux/tmux.conf"

  if [[ -f "${_TMUX_CONF}" ]] && grep -q -F -e "${_INSERT_TMUX_CONF}" "${_TMUX_CONF}" &> /dev/null; then
    echo "alread tmux.conf setup"
    return 0
  fi

  [[ -f "${_TMUX_CONF}" ]] && cp --backup=t -vpt "${_BACKUP_DIRECTORY}" "${_TMUX_CONF}"

  echo "source \"${_INSERT_TMUX_CONF}\"" >> $HOME/.tmux.conf
  # 末尾に改行挿入
  echo >> $HOME/.tmux.conf

}

echo ".profile setup start"
ProfileSetup
echo ".bashrc setup start"
BashrcSetup
echo ".tmux.conf setup start"
TmuxConfSetup

