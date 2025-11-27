" ------------------------------------------------------------------------------------
" == tiny

set tabstop=4
set number

set laststatus=2

set list
set listchars=tab:^.,trail:~

if !1 | finish | endif

" ------------------------------------------------------------------------------------
" == NeoBundle

set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=$HOME/vimfiles/neobundle/neobundle.vim
endif

call neobundle#begin(expand('~/vimfiles/neobundle'))
let g:neobundle_default_git_protocol='https'
let g:neobundle#types#git#pull_command='pull --rebase'

NeoBundleFetch 'Shougo/neobundle.vim'

let vimproc_updcmd = has('win64') ? 'tools\\update-dll-msvc.bat 64' : 'tools\\update-dll-msvc.bat 32'
execut "NeoBundle 'Shougo/vimproc.vim' , ". string({
\	'build' : {
\		'windows' : vimproc_updcmd,
\	},
\})

" NeoBundleFetch 'Shougo/neosnippet-snippets' , {
" \	"base" : "$HOME/vimfiles/.vimlocal"
" \}
NeoBundleFetch 'Shougo/neosnippet-snippets'

" - file
NeoBundle 'vim-scripts/a.vim'
"NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'Shougo/vimshell.vim'
" - info view
"NeoBundle 'sjl/gundo.vim'
"NeoBundle 'koron/minimap-vim'
"NeoBundle 'severin-lemaignan/vim-minimap'
"NeoBundle 'primitivorm/minimap-vim'
NeoBundle 'vim-scripts/taglist.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'vim-scripts/Visual-Mark'
"NeoBundle 'vim-scripts/wokmarks.vim'
"NeoBundle 'wesleyche/SrcExpl'
"NeoBundle 'vim-scripts/ShowMarks'
"NeoBundle 'grota/ShowMarks'
"NeoBundle 'thinca/vim-ref'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 't9md/vim-quickhl'
" - utility
NeoBundle 'vim-scripts/ShowMultiBase'
"NeoBundle 'vim-scripts/fuzzyjump.vim'
"NeoBundle 'osyo-manga/vim-gift'
"NeoBundle 'spolu/dwm.vim'
NeoBundle 'ljoaruma/dwm.vim'
NeoBundle 'vim-scripts/BufOnly.vim'
NeoBundle 'koron/codic-vim'
NeoBundle 't9md/vim-choosewin'
"NeoBundle 'othree/eregex.vim'
"NeoBundle 'kana/vim-operator-user'
"NeoBundle 'kana/vim-operator-replace'
NeoBundle 'tyru/restart.vim'
NeoBundle 'kana/vim-tabpagecd'
NeoBundle 'airblade/vim-rooter'
" - edit
NeoBundle 'tpope/vim-surround'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'vim-scripts/Align'
NeoBundle 'terryma/vim-multiple-cursors'
" - textobj
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-function'
NeoBundle 'kana/vim-textobj-syntax'
NeoBundle 'sgur/vim-textobj-parameter'
NeoBundle 'rhysd/vim-textobj-ruby'
" - operator
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-operator-replace'
" - unite
NeoBundle 'Shougo/unite.vim'
"NeoBundle 'Shougo/neocomplcache.vim'
if has('lua')
  NeoBundle 'Shougo/neocomplete.vim'
endif
NeoBundle 'Konfekt/FastFold'
NeoBundle 'Shougo/neoinclude.vim'
NeoBundle 'Shougo/neco-syntax'
NeoBundle 'Shougo/neosnippet.vim'
"NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'tacroe/unite-mark'
NeoBundle 'hewes/unite-gtags'
"NeoBundle 't9md/vim-unite-ack'
NeoBundle 'kannokanno/unite-dwm'
NeoBundle 'rhysd/unite-codic.vim'
NeoBundle 'mattn/unite-remotefile'
NeoBundle 'Shougo/tabpagebuffer.vim'
NeoBundle 'osyo-manga/vim-monster'
"NeoBundle ruby
NeoBundle 'thinca/vim-ref'
NeoBundle 'vim-ref/vim-ref-ri'

"Memo
"NeoBundle 'kien/ctrlp.vim'
"NeoBundle 'osyo-manga/vim-over'
"NeoBundle 'LeafCage/yankround.vim'
"NeoBundle 'vim-jp/vital.vim'

call neobundle#end()

filetype plugin on
filetype indent on
syntax on

" ------------------------------------------------------------------------------------
" == global settings

" can use prefix
" <Space> <CR> f t s <C-t> <C-y> <C-d> <C-u> , ; \ q

if !has('gui_running')
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

  "colorscheme default
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

  " その他カラーの設定
  hi clear CursorLine
  hi CursorLine ctermbg=darkgray
  hi clear MatchParen
  hi MatchParen term=bold ctermbg=black guibg=DarkCyan
endif

"if has("win32")
"  let &termencoding = &encoding
"endif

set termencoding=utf-8
"set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp

"change directory when open
" ファイルの存在するディレクトリをカレントディレクトリにする
" au   BufEnter *   execute ":cd " . expand("%:p:h")
"グローバル的に変更
command!  Cda execute ":cd " . expand("%:p:h")
" このファイルに対してのみ変更
command!  Cdl execute ":lcd " . expand("%:p:h")

" CD by shougo rc
nnoremap <silent> ;cd :<C-u>call <SID>cd_buffer_dir()<CR>
function! s:cd_buffer_dir() "{{{
  let filetype = getbufvar(bufnr('%'), '&filetype')
  if filetype ==# 'vimfiler'
    let dir = getbufvar(bufnr('%'), 'vimfiler').current_dir
  elseif filetype ==# 'vimshell'
    let dir = getbufvar(bufnr('%'), 'vimshell').save_dir
  else
    let dir = isdirectory(bufname('%')) ?
          \ bufname('%') : fnamemodify(bufname('%'), ':p:h')
  endif

  echo expand(dir)
  execute 'lcd' fnameescape(dir)
endfunction"}}}

" mouse settings

set mouse=a
set ttymouse=xterm2

" directorys
set tags=./tags;,tags;
"set tags+=Target/**/tags;
set backupdir^=$HOME\\vimfiles\\.vimlocal\\.bakfiles
set directory^=$HOME\\vimfiles\\.vimlocal\\.swpfiles
set undodir=$HOME\\vimfiles\\.vimlocal\\.undo
set path+=../inc,../src
let $PATH=$PATH.';c:/root/bin/Gow/bin;'
" - unite
let g:unite_data_directory = expand('$HOME/vimfiles/.vimlocal/.unite')
" - unit / mru
let g:neomru#file_mru_path = expand('$HOME/vimfiles/.vimlocal/.cache/file')
let g:neomru#directory_mru_path = expand('$HOME/vimfiles/.vimlocal/.cache/directory')
" - neocomplcache
let g:neocomplcache_temporary_dir = expand('$HOME/vimfiles/.vimlocal/.neocomplcache')
if has('lua')
  let g:neocomplete#data_directory = expand('$HOME/vimfiles/.vimlocal/.neocomplete')
endif
" - vimfiler
let g:vimfiler_data_directory = expand('$HOME/vimfiles/.vimlocal/.vimfiler')
" - vimshell
let g:vimshell_temporary_directory = expand('$HOME/vimfiles/.vimlocal/.vimshell')

" folding
set foldmethod=syntax
set foldlevel=20

" diff
set diffopt=internal,filler,algorithm:histogram,indent-heuristic

" buffer / window / tab
" nnoremap C :bd<CR>
nnoremap <silent> <C-C> :<C-u>call <SID>close_tab_last_delete_buffer()<CR>
function! s:close_tab_last_delete_buffer()
  let n_tabs = tabpagenr('$')
  let n_wins = winnr('$')
  if n_tabs != 1
    exec DWM_Close()
  elseif n_wins != 1
    exec DWM_Close()
  else
    bdelete "tab/windowひとつの時はバッファ削除
  endif
endfunction

nnoremap <silent> <C-W><C-O> :<C-u>call <SID>only_window()<CR>
function! s:only_window()
  let n_tabs = tabpagenr('$')
  let n_wins = winnr('$')
  if n_tabs != 1
    wincmd o
  elseif n_wins != 1
    wincmd o
  else
    call BufOnly('', '')
  endif
endfunction


" register
" nmap <CTRL-*> "*
" vmap <CTRL-*> "*

" other
set updatetime=600
set backupcopy=yes

nmap <silent> <ESC><ESC> :noh<CR>

"edit
nnoremap <silent> DD yy"_d0"_d$
nnoremap <silent> O<CR> O
nnoremap <silent> OO O<ESC>"_d0"_d$

" filetype(temporary)
au FileType ruby setlocal expandtab tabstop=2 shiftwidth=2

" color(temporary)
autocmd BufRead,BufNewFile * :syntax region HistoryComment start=+//☆+ end=+$+
autocmd BufRead,BufNewFile * :hi HistoryComment  guifg=#555544   ctermbg=8
autocmd BufRead,BufNewFile * :call <SID>set_sign_color()

function! s:set_sign_color()
  if &bg == "dark"
    highlight SignColor ctermfg=white ctermbg=blue guifg=white guibg=RoyalBlue3
  else
    highlight SignColor ctermbg=white ctermfg=blue guibg=grey guifg=RoyalBlue3
  endif
endfunction

" ------------------------------------------------------------------------------------
" == plug-in settings

" ====
" ChangeLog

let g:changelog_dateformat = "%Y-%m-%d"
let g:changelog_username = "nakamura"
nnoremap <Leader><Leader>c :new ~/ChangeLog<CR>

" ==
" rooter

"nnoremap <silent> <Leader>chr <Plug>RooterChangeToRootDirectory
"nnoremap <silent> ;chr <Plug>RooterChangeToRootDirectory
map <silent> ;ch <Plug>RooterChangeToRootDirectory
let g:rooter_diable_map = 1
let g:rooter_manual_only = 1
"let g:rooter_patterns = g:rooter_patterns + ['hoge']
let g:rooter_use_lcd = 1
let g:rooter_silent_chdir = 0

" ====
" Netrw
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_use_errorwindow = 0

" ====
" NERDTree
"nnoremap <F4> :NERDTreeToggle<CR>

" ====
" Tlist
let Tlist_Close_On_Select = 0
let Tlist_Show_One_File = 1
let Tlist_GainFocus_On_ToggleOpen = 1
nnoremap <F11> :TlistToggle<CR>

" ====
" Gtags -> unite-gtags
"nnoremap <F12> :GtagsCursor<CR>
"nnoremap <S-F12> :Gtags -r <C-R><C-W><CR>

" ====
" Gundo
"nnoremap <F5> :GundoToggle<CR>

" ====
" QuickFix

function! s:toggle_quick_fix()
  let _ = winnr('$')
  cclose
  if _ == winnr('$') "closeでウィンドウの数が変わらないなら開く
    cwindow
  endif
endfunction

"nnoremap  <silent> <S-Space> :<C-u>call <SID>toggle_quick_fix()<CR>
nnoremap <C-p> :cp<CR>
nnoremap <C-n> :cn<CR>

" ====
" a.vim
let g:alternateExtensions_cpp = "inl,h,hh,hpp"
let g:alternateExtensions_h = "cpp,c,inl,cxx,cc"
let g:alternateExtensions_inl = "cpp,c,h,cxx,cc"
" let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc'
nnoremap <C-S-Space> :<C-u>A<CR>

" ====
" indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#333344   ctermbg=8
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#444433  ctermbg=7
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=DarkGray   ctermbg=8
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=Gray  ctermbg=7

" ===
" vim-quickhl
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

nmap <Space>j <Plug>(quickhl-cword-toggle)
"nmap <Space>] <Plug>(quickhl-tag-toggle)
map H <Plug>(operator-quickhl-manual-this-motion)

" ====
" SrcExpl.vim

"let g:SrcExpl_isUpdateTags = 0
"let g:SrcExpl_refreshTime = 250
"let g:SrcExpl_updateTagsCmd = "ctags -R --sort=foldcase --tag-relative=yes --excmd=number --langmap=c++:.c++.cc.cp.cpp.cxx.h.h++.hpp.hxx.inl --exlucde=Test"
"nnoremap <S-F11> :SrcExplToggle<CR>

" ====
" workmarks.vim
let g:wokmarks_do_maps=2

" ====
" dwm

let g:dwm_map_keys=0
let g:dwm_master_pane_width="60%"

nnoremap <c-j> <c-w>w
nnoremap <c-k> <c-w>W
nmap <m-r> <Plug>DWMRotateCounterclockwise
nmap <m-l> <Plug>DWMRotateClockwise
nmap <c-n> <Plug>DWMNew
"nmap <c-c> <Plug>DWMClose
"nmap <c-@> <Plug>DWMFocus
nmap <c-Space> <Plug>DWMFocus
nmap <c-l> <Plug>DWMGrowMaster
nmap <c-h> <Plug>DWMShrinkMaster

" dwm? reset setting

nnoremap <silent> SV :call <SID>dwm_reset_settings()<CR>
function! s:dwm_reset_settings()
  set noautochdir
  set smartcase
  set ignorecase
  let g:dwm_master_pane_width='60%'
endfunction

" custome setting on my patch
let g:dwm_enable_switchback_on_focus = 0
let g:dwm_auto_enter_exist_filetype = '\v^(netrw|help|unite|taglist|vimfiler)$'
let g:dwm_enable_auto_enter = 0

" ====
" choosewin

let g:choosewin_overlay_enable = 1
let g:choosewin_overlay_clear_multibyte = 1
let g:choosewin_statusline_replace = 0
let g:choosewin_blink_on_land = 0
let g:choosewin_tabline_replace = 0
nmap - <Plug>(choosewin)

" ===
" restart

command!
\ -bar
\ RestartWithSession
\ let g:restart_sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages'
\ | Restart

let g:restart_check_window_maximized = 0

" ====
" gift

nnoremap <silent> <S-Space> <C-W><C-T>

" ===
" lightline

"let g:lightline = {
"  \   'active' : {
"  \     'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ],
"  \     'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ] ],
"  \   },
"  \   'mode_map' : {
"  \     'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL',
"  \     'V': 'V-LINE', 'c': 'COMMAND', "\<C-v>": 'V-BLOCK', 's': 'SELECT',
"  \     'S': 'S-LINE', "\<C-s>": 'S-BLOCK', '?': '      ' }
"  \   },
"  \ }

let g:lightline = {
  \ 'active' : {
  \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'current_tag', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileencoding', 'filetype' ] ],
  \   },
  \   'component_function': {
  \     'current_tag': 'GetCurrentTag',
  \   },
  \   'mode_map' : {
  \     'n': 'N', 'i': 'I', 'R': 'R', 'v': 'V',
  \     'V': 'V-L', 'c': 'CMD', "\<C-v>": 'V-BLK', 's': 'SLCT',
  \     'S': 'S-L', "\<C-s>": 'S-BLK', '?': '[-]',
  \   },
  \ }

function! GetCurrentTag()
  return tagbar#currenttag('%s', '')
endfunction

" ====
" neocomplcache
"set completeopt=menuone
"let g:neocomplcache_enable_at_startup = 1

"" neocomplcache - enable heavy omni completion
"if !exists('g:neocomplcache_omni_patterns')
"	let g:neocomplcache_omni_patterns = {}
"endif
"let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

"" neocomplcache - clang_complete
"let g:neocomplcache_force_overwrite_completefunc=1
"if !exists("g:neocomplcache_force_omni_patterns")
	"let g:neocomplcache_force_omni_patterns = {}
"endif

"" neocomplcache - omnifunc
"let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|::'

" ====
" clang_complete
" let g:clang_complete_auto=0

" ===
" neocomplete

if has('lua')

  set completeopt=menuone

  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
  let g:neocomplete#enable_fuzzy_completion = 1

  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#auto_completion_start_length = 3
  let g:neocomplete#manual_completion_start_length = 3
  let g:neocomplete#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
			\ 'default' : '',
			\ 'vimshell' : $HOME.'/vimfiles/.vimlocal/.vimshell_hist',
			\ 'scheme' : $HOME.'/vimfiles/.vimlocal/.gosh_completions'
			\ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr><C-l> neocomplete#complete_common_string()
  "
  inoremap <expr><C-y>  pumvisible() ? neocomplete#close_popup() :  "\<C-y>"
  inoremap <expr><C-e>  pumvisible() ? neocomplete#cancel_popup() : "\<C-e>"

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
	return (pumvisible() ? "\<C-y>" : ("" . "\<CR>"))
	"return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  	"return neocomplete#smart_close_popup() . "\<CR>"
	" For no inserting <CR> key.
	"return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  "inoremap <expr><C-y> neocomplete#close_popup()
  "inoremap <expr><C-e> neocomplete#cancel_popup()
  inoremap <expr><C-k> pumvisible() ? "\<C-y>" : "\<C-k>"
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() :
  ""\<Space>"

  " manual cache make (neo complete setting error?)
  nnoremap <silent> SA :call <SID>manual_neocomlete_make_cache()<CR>
  function! s:manual_neocomlete_make_cache()
	NeoCompleteTagMakeCache
	NeoCompleteSyntaxMakeCache
  "	NeoCompleteIncludeMakeCache
	NeoCompleteBufferMakeCache
  endfunction

  nnoremap <silent> SI :call <SID>manual_neocomplete_include_make_cache()<CR>
  function! s:manual_neocomplete_include_make_cache()

	let l_time = g:neocomplete#skip_auto_completion_time
	let l_processes = g:neocomplete#sources#include#max_processes

	let g:neocomplete#skip_auto_completion_time = ''
	let g:neocomplete#sources#include#max_processes = 20

	redraw
	let l:messageline = "start-[TagMakeCache]-"
	echo l:messageline
	NeoCompleteTagMakeCache

  "	redraw
  "	let l:messageline = l:messageline."[SyntaxMakeCache]-"
  "	echo l:messageline
  "	NeoCompleteSyntaxMakeCache

	redraw
	let l:messageline = l:messageline."[IncludeMakeCache]-"
	echo l:messageline
	NeoIncludeMakeCache

	redraw
	let l:messageline = l:messageline."[BufferMakeCache]-"
	echo l:messageline
	NeoCompleteBufferMakeCache

	redraw
	let l:messageline = l:messageline."complete"
	echo l:messageline

	let g:neocomplete#skip_auto_completion_time = l_time
	let g:neocomplete#sources#include#max_processes = l_processes

  endfunction

  " other setting
  let g:neocomplete#skip_auto_completion_time = "0.05"
  let g:neocomplete#release_cache_time = 86400
  let g:neocomplete#sources#include#max_processes = 0

  let g:monster#completion#rcodetools#backend = "async_rct_complete"
  let g:neocomplete#sources#omni#input_patterns = {
  \   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
  \}

endif

" ====
" neosnippet
"" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

"" <TAB> : Completion
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>" 

"" SuperTab like snippets behavior.
"imap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
"smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"" snippets
let g:neosnippet#disable_runtime_snippets = {
\   'c' : 1, 'cpp' : 1, 'inl' : 1, 'h' : 1,
\ }

"let g:neosnippet#snippets_directory=expand("$HOME/vimfiles/.vimlocal/snippets")
"let g:neosnippet#snippets_directory=expand("$HOME/vimfiles/.vimlocal/neosnippet-snippets/neosnippets")
let g:neosnippet#snippets_directory=expand("$HOME/vimfiles/neobundle/neosnippet-snippets/neosnippets")

" ====
" vimshell
let g:vimshell_user_prompt = 'getcwd()'

" ====
" vimfiler
let g:vimfiler_split_rule = 'aboveleft'
"nnoremap <F4> :VimFilerSplit -buffer-name=vim-filer-splitted -direction=aboveleft -toggle<CR>
nnoremap <F4> :VimFilerExplorer -buffer-name=vim-filer-explorer -direction=aboveleft -toggle<CR>
nnoremap <S-F4> :VimFilerBufferDir -buffer-name=vim-filer-horizon -horizontal -toggle -project<CR>
nnoremap <C-F4> :VimFilerDouble -tab -buffer-name=vim-filer-double<CR>

autocmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()
  nnoremap <silent><buffer><expr> f vimfiler#do_action('dwm_new')
  nnoremap <silent><buffer><expr> v vimfiler#do_action('vsplit')
  nnoremap <silent><buffer><expr> s vimfiler#do_action('split')
endfunction

" ------------------------------------------------------------------------------------
" == Unite
" let g:unite_enable_start_insert=1

call unite#custom#profile(
\  'default',
\ 'context',
\ {
\   'start_insert':1,
\   'direction':"aboveleft"
\ }
\)

let g:neomru#file_mru_limit = 20
let g:unite_source_file_mru_limit = 20
let g:unite_source_file_mru_long_limit = 1000
let g:neomru#directory_mru_limit = 20
let g:unite_source_directory_mru_limit = 20
let g:unite_source_directory_mru_long_limit = 1000


"let g:unite_split_rule = 'aboveleft'

nnoremap [unite] <Nop>
nmap ; [unite]

" operation of unite
nnoremap [unite] <Nop>
nnoremap [unite], :UniteResume -no-start-insert -no-quit -keep-focus -no-auto-preview<CR>
nnoremap [unite]u :Unite 

" list of files
nnoremap [unite]t :Unite dwm buffer_tab tab<CR>
nnoremap [unite]b :Unite dwm buffer tab<CR>
nnoremap [unite]r :Unite bookmark neomru/file neomru/directory<CR>
nnoremap [unite]f :UniteWithBufferDir bookmark file directory file/new<CR>

" find and jump
nnoremap [unite]<S-j> :Unite mark<CR>
nnoremap [unite]<S-p> :Unite jump<CR>
nnoremap [unite]<S-l> :Unite line:forward -buffer-name=line-matches<CR>
nnoremap <F3> :Unite line:forward -resume -buffer-name=line-matches -no-quit -no-start-insert<CR>
"nnoremap [unite]<S-g> :Cdl<CR>:Unite grep -auto-preview -buffer-name=grepped<CR>
nnoremap [unite]<S-g> :Unite grep -auto-preview -buffer-name=grepped<CR>
"nnoremap [unite]# :Cdl<CR>:Unite grep -auto-preview -resume -buffer-name=grepped -no-start-insert -no-quit<CR>
nnoremap [unite]# :Unite grep -auto-preview -resume -buffer-name=grepped -no-start-insert -no-quit<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  nnoremap <silent><buffer><expr> <F4> unite#do_action('vimfiler')
  nnoremap <silent><buffer><expr> f unite#do_action('dwm_new')
  nnoremap <silent><buffer><expr> v unite#do_action('vsplit')
  nnoremap <silent><buffer><expr> s unite#do_action('split')
endfunction

" ====
" unite-menu
nnoremap [unite]<S-m> :Unite menu:shortcut<CR>
let g:unite_source_menu_menus = {
\	"shortcut" : {
\		"command_candidates" : [
\			["remove right blank", "s/\s$//g"],
\			["tabopen edit _vimrc", "tabnew $MYVIMRC"],
\			["tabopen edit gvimrc", "tabnew $MYGVIMRC"],
\			["edit _vimrc", "split $MYVIMRC"],
\			["edit gvimrc", "split $MYGVIMRC"],
\			["read _vimrc", "source $MYVIMRC"],
\			["read gvimrc", "source $MYGVIMRC"],
\			["unite-grep","Unitevimgrep"],
\		],
\	},
\}

" ====
" unite-outline
nnoremap [unite]o :Unite outline<CR>

" ====
" unite-tag
nnoremap [unite]<S-F12> :UniteWithCursorWord -immediately -auto-preview tag<CR>
" nnoremap [unite]<S-F12> :UniteWithCursorWord -immediately tag<CR>

" ====
" hewes unite-gtags
nnoremap [unite]<S-d> :Unite gtags/def:
nnoremap <F12> :Unite gtags/context -auto-preview -start-insert<CR>
nnoremap <C-F12> :Unite gtags/def -auto-preview -start-insert<CR>
nnoremap <S-F12> :Unite gtags/ref -auto-preview -start-insert<CR>

let g:unite_source_gtags_project_config = {
\ '_':					{ 'treelize' : 0, 'absolute_path' : 0 }
\ }

" temp
let g:unite_source_gtags_ref_option = "rs"
let g:unite_source_gtags_def_option = "d"

" ===
" unite-grep
"let g:unite_source_grep_command = 'ag'
"let g:unite_source_grep_default_opts = '--nocolor --nogroup --hidden --line-numbers'
"let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_max_candidates = 65535

"let g:unite_source_grep_command = 'ack'
"let g:unite_source_grep_default_opts = '--no-heading --no-color -a'

" install jvgrep
" SET GOPATH="go path"
" go get code.google.com/p/mahonia
" go get github.com/mattn/jvgrep
" go install -v -x -a code.google.com/p/mahonia
" go install -v -x -a github.com/mattn/jvgrep
" update -> go get -u ~~~

let $JVGREP_OUTPUT_ENCODING='sjis'
let g:unite_source_grep_command = 'jvgrep'
let g:unite_source_grep_default_opts = '--exclude ''\.(git|svn|hg|bzr)'''
let g:unite_source_grep_recursive_opt = '-R'

