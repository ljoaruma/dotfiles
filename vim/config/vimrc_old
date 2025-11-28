" vim : set ts=2 sw=2 et filetype=vim :

" https://github.com/vim-jp/issues/issues/578
set t_u7=
set t_RV=

set nocompatible

set encoding=utf-8
scriptencoding utf-8
" ↑文字コード設定

" ターミナル設定
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" ランタイムパスに当該ディレクトリ以下を追加する
let s:rn_directory = expand('<sfile>:p:h') . '/vim'

let s:store_runtimepath=&runtimepath
let s:store_runtimepath=s:store_runtimepath . ',' . s:rn_directory
let s:store_runtimepath=s:store_runtimepath . ',' . s:rn_directory . '/after'
let &runtimepath=s:store_runtimepath

" 画面

syntax enable

if filereadable(expand('~/.vim/colors/solarized.vim')) || filereadable(expand(s:rn_directory . '/colors/solarized.vim'))

  if has('gui_running')
    set background=light
  else
    set background=dark
  endif

  colorscheme solarized
  let g:solarized_termcolors=256

else

  colorscheme desert

endif

set number
set cmdheight=2

set laststatus=2
set cursorline
set cursorcolumn
set display=lastline

set visualbell


" 編集
set ts=2
set expandtab
set shiftwidth=2

set autoindent
set smartindent

" 移動

nnoremap <C-j> <C-w>w
nnoremap <C-k> <C-w>W
nnoremap <C-l> gt
nnoremap <C-h> gT

" バッファ

set hidden

