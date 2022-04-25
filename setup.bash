#!/usr/bin/env bash
# vim: set expandtab ts=2 fenc=utf-8 ff=unix filetype=bash :

if [[ ! -v HOME ]]; then
  echo "no environment HOME"
  exit 1
fi

if which gdate &> /dev/null; then

  date () {
    gdate "$@"
  }

fi

if which gcp &> /dev/null; then
  cp () {
    gcp "$@"
  }
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

  cp --backup=t -vpLt "${_BACKUP_DIRECTORY}" "${_PROFILE}"

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

if [[ -f "${_FULLPATH_SOURCE_DIRECTORY}/${_INSERT_BASHRC}" ]]; then
  source "${_FULLPATH_SOURCE_DIRECTORY}/${_INSERT_BASHRC}"
fi
EOL
  )

  if [[ ! -e "${_BASHRC}" ]]; then
    touch "${_BASHRC}" && \
    chmod 644 "${_BASHRC}" && \
    echo "${_INSERT_SOURCE_COMMAND}" >> "${_BASHRC}"

    return 0
  fi

  if grep -q -F "${_FULLPATH_SOURCE_DIRECTORY}" "${_BASHRC}" &> /dev/null; then
    echo "bashrc already setup"

    return 0
  fi

  cp --backup=t -vpLt "${_BACKUP_DIRECTORY}" "${_BASHRC}"
  local -r _BASHRC_ORG="${_BACKUP_DIRECTORY}/.bashrc"

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

  if [[ -e "${_TMUX_CONF}" ]] && grep -q -F -e "${_INSERT_TMUX_CONF}" "${_TMUX_CONF}" &> /dev/null; then
    echo "alread tmux.conf setup"
    return 0
  fi

  [[ -e "${_TMUX_CONF}" ]] && cp --backup=t -vpLt "${_BACKUP_DIRECTORY}" "${_TMUX_CONF}"

  echo "source \"${_INSERT_TMUX_CONF}\"" >> $HOME/.tmux.conf
  # 末尾に改行挿入
  echo >> $HOME/.tmux.conf

}

function VimRcSetup() {
  local -r _VIMRC="${HOME}/.vimrc"
  local -r _INSERT_VIMRC="${_SOURCE_DIRECTORY}/vimrc"

  if [[ -e "${_VIMRC}" ]] && grep -q -F -e "${_INSERT_VIMRC}" "${_VIMRC}" &> /dev/null; then
    echo "alread tmux.conf setup"
    return 0
  fi

  [[ -e "${_VIMRC}" ]] && cp --backup=t -vpLt "${_BACKUP_DIRECTORY}" "${_VIMRC}"

#  echo "source \"${_INSERT_VIMRC}\"" >> "${_VIMRC}"
#  echo "" >> "${_VIMRC}"

  cat - <<EOL >> "${_VIMRC}"
if filereadable('${_INSERT_VIMRC}')
  source ${_INSERT_VIMRC}
endif
EOL
  echo "" >> "${_VIMRC}"

}

echo ".profile setup start"
ProfileSetup
echo ".bashrc setup start"
BashrcSetup
echo ".tmux.conf setup start"
TmuxConfSetup
echo ".vimrc setup start"
VimRcSetup


echo "echo setup directries"
mkdir -vp $HOME/usr/{src,bin,lib,include,sbin,share,opt}
mkdir -vp $HOME/usr/bin/local/bin
mkdir -vp $HOME/usr/share/man
mkdir -vp $HOME/var/log
mkdir -vp $HOME/tmp
mkdir -vp $HOME/works

