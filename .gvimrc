" ------------------------------------------------------------------------------------
" == global settings

" font
"set guifont=MS_Gothic:h9:cSHIFTJIS
set guifont=BDF_UM+,MS_Gothic:h9:cSHIFTJIS
" window size
set columns=120
set lines=100
set cmdheight=2
" view
set laststatus=2
set number
set cursorcolumn
set cursorline
set ruler
" edit
set ts=4
set shiftwidth=4

" ------------------------------------------------------------------------------------
" == .gvimrc カラー設定

"colorscheme mycolor
colorscheme desert

" カラー設定した後にCursorIMを定義する方法
if has('multi_byte_ime')
  highlight Cursor guifg=NONE guibg=Green
  highlight CursorIM guifg=NONE guibg=Red
endif

" タブと「行末の半角スペース」の協調表示
set list
set listchars=tab:^.,trail:~
highlight SpecialKey term=bold ctermfg=2 guifg=yellowgreen

" ------------------------------------------------------------------------------------
" == 未使用・使用キー割り当てを確認する方法

" help index.txt
" verbose map
" map
" nmap
" imap
" vmap
