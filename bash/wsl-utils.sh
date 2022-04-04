#!/bin/bash

if which wslpath > /dev/null 2>&1 ; then

  function wslpush() {
    #echo "echo"
    #echo "$1"
    #echo "printf%1"
    #printf "%q\n" "$1"
    #echo "wslpath"
    #wslpath "$1"
    #echo "wslpath printf%1"
    #wslpath $(printf "%q" "$1")
    #pushd "$(eval wslpath \'"$1"\')"
    #echo "pushd"
    #pushd "$(printf "%q" $(wslpath $(printf "%q", "$1")))"
    #pushd "$(wslpath $(printf "%q"  "$1" ))"
    #pushd "$(wslpath "${}")"
    pushd .
    wslcd "$1"
    #local onwslpath=$(wslpath "$1")
    #echo "$1 -> ${onwslpath}"
    #if [[ -f "${onwslpath}" ]]; then
    #  onwslpath="$(dirname "${onwslpath}")"
    #  echo "${onwslpath}"
    #fi

    #pushd "${onwslpath}"
  }

  export -f wslpush

  # net use コマンドからネットワークドライブ情報を取得
  function __network_drives () {
    type net.exe &> /dev/null || exit 0
    net.exe use | awk '$0~/^OK/ { printf "%s\t%s\n", $2, $3 } '
  }

  # ネットワークドライブテーブル
  # キー文字列 ネットワークドライブ文字(ex. Y: )
  declare -A __WSL_NETWORK_DRIVE=()

  # net useコマンドから取得したネットワークドライブ情報をテーブルへ格納
  function __init_networkdrive_mapping() {
    __WSL_NETWORK_DRIVE=()

    local __device=""
    local __mount_point=""
    while IFS=$'\t' read -r __device __mount_point; do
      __WSL_NETWORK_DRIVE["${__device}"]="${__mount_point}"
    done < <( __network_drives)
  }

  # mount コマンドからwslがマウントしたドライブ情報取得
  # 対象とするのは、type 9pでマウントしたドライブで、'\'を含む列
  function __mount_drives () {
    mount | grep "type 9p" | grep '\\' | sed 's|^\([^[:blank:]]*\)[[:blank:]]\+on[[:blank:]]\+\([^[:blank:]].*[^[:blank:]]\)[[:blank:]]\+type 9p[[:blank:]]\+.*$|\1\t\2|g'
  }

  # WSLがマウントしたドライブ情報テーブル
  # キー文字列 ドライブ文字(\マークまで)(ex. C:\ )
  declare -A __WSL_MOUNT_TABLE

  # mountコマンドから取得したドライブ情報をテーブルへ格納
  function __init_mount_mapping() {
    __WSL_MOUNT_TABLE=()

    local __device=""
    local __mount_point=""
    while IFS=$'\t' read -r __device __mount_point; do
      __WSL_MOUNT_TABLE["${__device}"]="${__mount_point}"
    done < <( __mount_drives)
  }

  
  # 文字列がWindows上のパスか判定する
  function __is_winpath() {

    #set -xTu
    #declare -p __WSL_MOUNT_TABLE

    if [[ $# -lt 1 ]]; then
      #set +xTu

      return 1
    fi

    local -r __input_path="${1}"

    ## 先頭がスラッシュのケースや、'./',  また、'.'1文字のケースはLinuxパスと判定する

    #echo "-- check first letter" >&2

    if [[ "/" = "${__input_path:0:1}" ]]; then
      #echo "-- first letter slash" >&2
      #set +xTu

      return 127
    fi

    if [[ "./" = "${__input_path:0:2}" ]]; then
      #echo "-- first letter dot slash" >&2
      #set +xTu

      return 127
    fi

    if [[ 1 -eq ${#__input_path} ]] && [[ "." = "${__input_path}" ]]; then
      #echo "-- dot only" >&2
      #set +xTu

      return 127
    fi

    ## 先頭3文字がマウントしているドライブ文字であれば、Windowsパスと判定する
    ## -vテスト(定義有無)の判定に用いるインデックスはエスケープする必要があるので、エスケープ文字列も用意する

    local -u __INPUT_DRIVE_NAME="${__input_path:0:3}"
    local -u __INPUT_DRIVE_NAME_ESCAPED="$(printf '%q' "${__input_path:0:3}")"

    if [[ -v __WSL_MOUNT_TABLE["${__INPUT_DRIVE_NAME_ESCAPED}"] ]] && 
       [[ ! -z ${__WSL_MOUNT_TABLE["${__INPUT_DRIVE_NAME}"]} ]]; then
      #set +xTu

      return 0
    fi

    ## スラッシュを含まず、円マークを含む場合は、Windowsパスと判定する
    if [[ ! "${__input_path}" = */* ]] && [[ "${__input_path}" = *\\* ]]; then
      #echo "-- noinclude slash, and include yen mark"
      #set +xTu

      return 0
    fi

    # とりあえず上記以外はLinuxパスとしておく

    #set +xTu

    return 126

  }

  export -f __is_winpath

  function wslcd() {
    if __is_winpath "$1"; then
      local onwslpath="$(wslpath "$1")"
    else
      local onwslpath="$1"
    fi

    echo "$1 -> ${onwslpath}"
    if [[ -f "${onwslpath}" ]]; then
      echo -n "${onwslpath} -> "
      onwslpath="$(dirname "${onwslpath}")"
      echo "${onwslpath}"
    fi

    cd "${onwslpath}"
	}

  export -f wslcd

  function smbpath() {
    #set -xTu

    if [[ $# -eq 0 ]]; then

      cat <<EOL
書式
usage $0 [OPTIONS] [--] file

説明
目的のファイル名称が、sambaドライブ上にある場合、当該sambaサーバ上のパスへ変換する。

-f, --canonicalize
      与えられた名前の要素中に存在するシンボリックリンクを 再帰的に全て辿る。最後の要素以外は存在しなければいけ ない

-e, --canonicalize-existing
      与えられた名前の要素中に存在するシンボリックリンクを 再帰的に全て辿る。最後の要素も含めて全て存在しなけれ ばいけない

-m, --canonicalize-missing
      与えられた名前の要素中に存在するシンボリックリンクを 再帰的に全て辿る。要素が存在しなくてもよい

-v, --verbose
      処置中の詳細情報を標準エラー出力へ出力する

-L, --dereference
      指定のファイルがシンボリックリンクの場合にたどる。

-P, --no-dereference
      シンボリックリンクを決してたどらない

EOL

      return 0
    fi

    ## analyze options

    local -A __readlink_args=()
    local __verbose=0
    local __dereference=1

    while [[ $# -gt 1 ]]; do
      case "$1" in
        -v|--verbose)
          __verbose=1; shift ;;
        -L|--dereference)
          __dereference=1; shift ;;
        -P|--no-dereference)
          __dereference=0; shift ;;
        -f|--canonicalize)
          __readlink_args["--canonicalize"]=1; shift ;;
        -e|--canonicalize-existing)
          __readlink_args["--canonicalize-existing"]=1; shift ;;
        -m|--canonicalize-missing)
          __readlink_args["--canonicalize-missing"]=1; shift ;;
        --)
          shift; break ;;
        *)
          break ;;
      esac
    done

    readonly __verbose
    readonly __readlink_args
    readonly __dereference

    local -r __input_path="$1"

    ## convert to WSL path

    [[ 0 -ne "${__verbose}" ]] && echo "-- to wsl path" >&2

    if __is_winpath "${__input_path}"; then
      [[ 0 -ne "${__verbose}" ]] && echo "---- win path" >&2
      local -r __onwslpath="$(wslpath -a "$1")"
    else
      [[ 0 -ne "${__verbose}" ]] && echo "---- not win path" >&2
      local -r __onwslpath="$1"
    fi

    [[ 0 -ne "${__verbose}" ]] && echo "${__input_path}" >&2 && echo "-> ${__onwslpath}" >&2

    ## dereference name

    local __dereference_name="$(
      if [[ 0 -eq "${__dereference}" ]]; then
        [[ 0 -ne "${__verbose}" ]] && echo "-- no dereference" >&2
        echo "${__onwslpath}"
      else
        [[ 0 -ne "${__verbose}" ]] && echo "-- dereference" >&2
        local -a __readlink_actual_args=("${!__readlink_args[@]}")
        [[ 0 -ne "${__verbose}" ]] && __readlink_actual_args+=("--verbose") && echo "readlink args -> ${__readlink_actual_args[@]}" >&2
        readlink "${__readlink_actual_args[@]}" "${__onwslpath}" 2> /dev/null || echo "${__onwslpath}"
      fi
    )"

    [[ 0 -ne "${__verbose}" ]] && echo "-> ${__dereference_name}" >&2

    ## to absolute path

    if [[ -d "${__dereference_name}" ]]; then
      # directory path, use pwd
      [[ 0 -ne "${__verbose}" ]] && echo "-- directory path" >&2
      local -r abs_wsl_path="$(cd "${__dereference_name}" && pwd)"

    elif [[ -f "${__dereference_name}" ]]; then
      # normal file path, use pwd for dirname
      [[ 0 -ne "${__verbose}" ]] && echo "-- normal file path" >&2
      local -r abs_wsl_path="$(cd "$(dirname "${__dereference_name}")" && pwd)/$(basename "${__dereference_name}")"

    elif [[ ! -e "${__dereference_name}" ]]; then
      # not found path, recurivility search

      [[ 0 -ne "${__verbose}" ]] && echo "-- not found path : ${__dereference_name}" >&2
      local __recursive_base_name="$(basename "${__dereference_name}")"
      local __recursive_dir_name="$(dirname "${__dereference_name}")"

      ## search exist directory, recurisiviry up to
      while [[ ! "/" = "${__recursive_dir_name}" ]] && [[ ! "." = "${__recursive_dir_name}" ]]; do
        if [[ -d "${__recursive_dir_name}" ]]; then
          [[ 0 -ne "${__verbose}" ]] && echo "found ${__recursive_dir_name}" >&2

          local -r abs_wsl_path="$(cd "${__recursive_dir_name}" && pwd)/${__recursive_base_name}"
          break
        fi

        [[ 0 -ne "${__verbose}" ]] && echo "---- not found ${__recursive_dir_name}" >&2

        __recursive_base_name="$(basename "${__recursive_dir_name}")/${__recursive_base_name}"
        __recursive_dir_name="$(dirname "${__recursive_dir_name}")"

      done

      ## not exist when, root directory

      if [[ "/" = "${__recursive_dir_name}" ]]; then
        [[ 0 -ne "${__verbose}" ]] && echo "-- not found /${__recursive_base_name}" >&2
        local -r abs_wsl_path="/${__recursive_base_name}"
      elif [[ "." = "${__recursive_dir_name}" ]]; then
        [[ 0 -ne "${__verbose}" ]] && echo "-- not found /${__recursive_base_name}" >&2
        local -r abs_wsl_path="$(pwd -P)/${__recursive_base_name}"
      fi

    else

      # other case(not directory, not normal file, and exist)(special file?)

      [[ 0 -ne "${__verbose}" ]] && echo "not direcotyr, not normal file, and found path" >&2 && echo "-> ${__dereference_name}" >&2
      local -r abs_wsl_path="$(cd "$(dirname "${__dereference_name}")" && pwd -P)/$(basename "${__dereference_name}")"

    fi

    echo "${abs_wsl_path}" |
    sed \
      -e 's|/mnt/y/|/data/garbages/|g' \
      -e 's|/mnt/w/|/data/datas/|g' \
      -e 's|/mnt/x/|/data/musics/|g'

    #set +xTu
  }

  export -f smbpath

  __init_networkdrive_mapping
  __init_mount_mapping

fi

#WIN_FFMPEG_INSTALL_DIR="$(wslpath 'C:\r\usr\ffmpeg\ffmpeg-4.4.1-full_build')"
WIN_FFMPEG_INSTALL_DIR="$(wslpath 'C:\r\usr\ffmpeg\ffmpeg-5.0-full_build')"

if [[ -x "${WIN_FFMPEG_INSTALL_DIR}/bin/ffmpeg.exe" ]]; then
  export WIN_FFMPEG_INSTALL_DIR

  function ffmpeg() {
    "${WIN_FFMPEG_INSTALL_DIR}/bin/ffmpeg.exe" "$@"
  }

  export -f ffmpeg

fi

if [[ -x "${WIN_FFMPEG_INSTALL_DIR}/bin/ffprobe.exe" ]]; then
  export WIN_FFMPEG_INSTALL_DIR

  function ffprobe() {
    "${WIN_FFMPEG_INSTALL_DIR}/bin/ffprobe.exe" "$@"
  }

  export -f ffprobe

fi

if ! declare -p WIN_FFMPEG_INSTALL_DIR | grep -q 'declare[[:blank:]]\+-[[:alpha:]]*x' > /dev/null; then
  unset WIN_FFMPEG_INSTALL_DIR
fi

# Windows Terminalでカレントディレクトリの引き継ぎ OSC 9;9

if [[ ! -v TMUX ]]; then

  function _windows_terminal_osc_9_9 {
      # Inform Terminal about shell current working directory
      # see: https://docs.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory
      #      https://github.com/microsoft/terminal/issues/8166
      #      https://github.com/microsoft/terminal/issues/3158
      printf "\e]9;9;%s\e\\" "$(wslpath -w "$(pwd)")"
  }

  PROMPT_COMMAND="${PROMPT_COMMAND:+"${PROMPT_COMMAND};"}_windows_terminal_osc_9_9"

fi


