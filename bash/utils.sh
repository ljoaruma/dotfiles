#!/bin/bash

# wslの場合だけのユーティリティ関数追加
if [[ -v WSL_DISTRO_NAME ]]; then
  source "$(dirname "${BASH_SOURCE}")"/wsl-utils.sh
fi

