let s:rn_directory = expand('<sfile>:p:h') . '/vim'

let s:store_runtimepath=&runtimepath
let s:store_runtimepath=s:store_runtimepath . ',' . s:rn_directory
let s:store_runtimepath=s:store_runtimepath . ',' . s:rn_directory . '/after'
let &runtimepath=s:store_runtimepath

set ts=2
set expandtab
set shiftwidth=2

nnoremap <C-j> <C-w>w
nnoremap <C-k> <C-w>W
nnoremap <C-l> gt
nnoremap <C-l> gT

set hidden

