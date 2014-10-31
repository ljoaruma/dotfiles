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
" == .gvimrc �J���[�ݒ�

"colorscheme mycolor
colorscheme desert

" �J���[�ݒ肵�����CursorIM���`������@
if has('multi_byte_ime')
  highlight Cursor guifg=NONE guibg=Green
  highlight CursorIM guifg=NONE guibg=Red
endif

" �^�u�Ɓu�s���̔��p�X�y�[�X�v�̋����\��
set list
set listchars=tab:^.,trail:~
highlight SpecialKey term=bold ctermfg=2 guifg=yellowgreen

" ------------------------------------------------------------------------------------
" == ���g�p�E�g�p�L�[���蓖�Ă��m�F������@

" help index.txt
" verbose map
" map
" nmap
" imap
" vmap
