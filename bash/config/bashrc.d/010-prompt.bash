#!/bin/bash
# vim: set expandtab ts=2 fenc=utf-8 ff=unix filetype=sh :

# プロンプト設定
# ---

# プロンプトの情報
# ---
# debian_chroot chroot 使用中かを示す
# \u ユーザ名
# \h ホスト名(最初のドットまで)
# \n 改行
# \r 復帰
# \w カレントディレクトリ
# \j ジョブ数
# \t HH:MM:SS 24時間制の時間
# /D{format} formatがstrftimeに渡された結果の文字列
# \$ uidが0の場合#, それ以外は$
# \[ ... \] シーケンスの開始から終了
# \[\e[..\] 装飾開始 \[\e[0m\] 装飾終了
# カラーシーケンスについて
## 16色カラー
## \033[属性;前景色;背景色m
## 256色カラー
## 前景色 \033[38;5;色番号m
## 背景色 \033[48;5;色番号m
## カラーシーケンス一覧
## for ((i = 0; i < 16; i++)); do for ((j = 0; j < 16; j++)); do for ((k = 0; k < 16; k++)); do for ((l = 0; l < 16; l++)); do hex=$(($i*16 + $j)); hex2=$(($k*16 + $l)); printf '\e[38;5;%dm\e[48;5;%dm%03d-%03d\e[m ' $hex $hex2 $hex $hex2; done; echo ""; done; done; done
## 24bitカラー
## 前景色 \033[38;2;赤;緑;青m
## 背景色 \033[48;2;赤;緑;青m
# その他エスケープシーケンス
## \E7 保存
## \E8 復帰

__prompt_decorate_end='\[\e[00m\]'
__prompt_bar_color='47'
__prompt_time_color='\[\e[0;30;46m\]'
__prompt_time_color_terminate='\[\e[0;36;45m\]▶ '
__prompt_dirs='$(dirs -v | grep -q "^[[:blank:]]*1" || exit; echo -n "["; dirs -l -v | tail -n +2 | head -n 4 | sed '\''s/^[[:blank:]]*\([[:digit:]]\+\)[[:blank:]]*\(.*\)/<\1: \2>/g'\'' | tr "\n''" " "; echo -n "] ")'
__prompt_dirs_color='\[\e[0;37;45m\]'
__prompt_dirs_color_terminate='\[\e[0;35;43m\]▶ '
__prompt_jobs_color='\[\e[0;35;43m\]'
__prompt_jobs_color_terminate=${__prompt_jobs_color_terminate}'\[\e[0;33m\]▶ '
__prompt_userhost_color='\[\e[0;30;46m\]'
__prompt_userhost_color_terminate='\[\e[0;36;45m\]▶ '
__prompt_cwd_color='\[\e[0;37;45m\]'
__prompt_cwd_color_terminate='\[\e[0;35;${__prompt_bar_color}m\]▶ '

# プロンプト設定本体
# ---
# 以下のプロンプト
# debian_chroot、日付、pushdディレクトリ群、バックグラウンドジョブ数
# ユーザ名@ホスト名:PWD

## プロンプト1行目 debian_chroot, 日付, pushdディレクトリ群, バックグラウンドジョブ数
PS1='\[\e]0;\u@\h: \w\a\]\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}'
PS1+=${__prompt_time_color}'\D{%y-%m-%d %H:%M:%S} '${__prompt_time_color_terminate}
PS1+=${__prompt_dirs_color}${__prompt_dirs}${__prompt_dirs_color_terminate}
PS1+=${__prompt_jobs_color}'J:\j '${__prompt_jobs_color_terminate}
PS1+=$__prompt_decorate_end'\n'

## プロンプト2行目 ユーザ名@ホスト名 PWD
PS1+='\[\e[0;;'${__prompt_bar_color}'m\]\r$(printf "%*s" ${COLUMNS:-40} " ")\r'
PS1+=$__prompt_userhost_color' \u@\h '${__prompt_userhost_color_terminate}$__prompt_decorate_end
PS1+=${__prompt_cwd_color}' \w '${__prompt_cwd_color_terminate}${__prompt_decorate_end}

## プロンプト3行目 $
PS1+='\n\$ '

