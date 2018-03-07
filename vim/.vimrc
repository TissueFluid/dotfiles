let my_plugin_home = $HOME . '/.vim/plugged'

"--------------------------------
" Use vim-plug to manage plugins
"--------------------------------
call plug#begin(my_plugin_home)

" File navigation
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-rooter'

" Code navigation
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'mileszs/ack.vim'
Plug 'farmergreg/vim-lastplace'

" Buffer management
Plug 'fholgado/minibufexpl.vim'

" Code completion
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Pairing
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'Valloric/MatchTagAlways'

" vim scripts
Plug 'Shougo/neco-vim', { 'for': 'vim' }

" golang
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': my_plugin_home . '/gocode/vim/update.sh' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
" Plug 'othree/jspc.vim'

" Welcome screen
Plug 'mhinz/vim-startify'

" Color schemes
Plug 'blueshirts/darcula'

" Indentation
Plug 'tpope/vim-sleuth'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'editorconfig/editorconfig-vim'

" Alignment
Plug 'godlygeek/tabular'

" Zhuangbility
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'

" Whitespace guide
Plug 'ntpeters/vim-better-whitespace'

" Source control
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Comment
Plug 'tpope/vim-commentary'

" Syntax & Lint
Plug 'w0rp/ale'

" Shell inside vim
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim', { 'do' : 'make' }
Plug 'Shougo/vimshell.vim'

" Initialize plugin system
call plug#end()

"---------------------------
" Personal vim configration
"---------------------------
if has('gui_running')
  if has('gui_win32')
    " set guifont=DejaVuSansMono\ Nerd\ Font\ Mono:h12
    set guifont=Hack\ Nerd\ Font\ Mono:h12
  endif
else
  set t_Co=256
endif

set nu
set ruler
set hlsearch
set incsearch
set showcmd
set encoding=utf8
set scrolloff=4
set noshowmode
set laststatus=2
set tabstop=4
set undofile
set undodir=~/.vim/undodir
set ffs=unix,dos,mac
set wildmenu
set backspace=indent,eol,start
set cursorline
set noeb vb t_vb=
if has('autocmd')
  autocmd GUIEnter * set vb t_vb=
  autocmd GUIEnter * simalt ~x
endif
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

colorscheme darcula

"-------------------
" Utility Functions
"-------------------
function! Chomp(string)
  return substitute(a:string, '\n\+$', '', '')
endfunction

"----------------------
" Plugin configuration
"----------------------
" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_close_preview = 1
let g:neocomplete#syntax#min_keyword_length = 3
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.javascript = '[^.\t]\.\w*'

if !exists('g:neocomplete#sources#omni#functions')
  let g:neocomplete#sources#omni#functions = {}
endif
" let g:neocomplete#sources#omni#functions.javascript = [
"       \ 'jspc#omni',
"       \ 'tern#Complete',
"       \ ]

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType javascript setlocal omnifunc=tern#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" git-gutter
if executable('ag')
  let g:gitgutter_grep = 'ag'
  " let g:gitgutter_grep_command = 'ag --nocolor'
endif

" ale
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
let g:ale_sign_column_always = 0
let g:ale_open_list = 0
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" tagbar
if has('win32')
  if executable('ctags')
    let g:tagbar_ctags_bin = Chomp(system('where ctags'))
  endif
endif
let g:tagbar_iconchars = ['▶', '▼']

" javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" golang
let g:go_fmt_command = "goimports"
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_type_info = 1

if executable('gotags')
  let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
          \ 'p:package',
          \ 'i:imports:1',
          \ 'c:constants',
          \ 'v:variables',
          \ 't:types',
          \ 'n:interfaces',
          \ 'w:fields',
          \ 'e:embedded',
          \ 'm:methods',
          \ 'r:constructor',
          \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
          \ 't' : 'ctype',
          \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
          \ 'ctype' : 't',
          \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
  \ }
endif

" lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [
      \     ['mode', 'paste'],
      \     ['fugitive', 'readonly', 'filename', 'modified']
      \   ],
      \   'right': [
      \     ['lineinfo'],
      \     ['percent'],
      \     ['fileformat', 'fileencoding', 'filetype'],
      \     ['linter_warnings', 'linter_errors', 'linter_ok']
      \   ]
      \},
      \ 'component': {
      \   'lineinfo': ' %3l:%-2v',
      \ },
      \ 'component_function': {
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'ok'
      \ }
      \ }
function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction
function! LightlineFugitive()
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? ''.branch : ''
  endif
  return ''
endfunction
function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ▲', all_non_errors)
endfunction
function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction
function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction
" Update and show lightline but only if it's visible (e.g., not in Goyo)
autocmd User ALELint call s:MaybeUpdateLightline()
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

" indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['nerdtree', 'startify', 'help', 'vimshell']

" html tag
let g:closetag_filenames = '*.html,*.xhtml,*phtml'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
let g:closetag_emptyTags_caseSensitive = 1

" nerdtree
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['node_modules', '\.swp$']

" ctrlp
let g:ctrlp_custom_ignore = 'node_modules\|git\|\.swp$'

" command alias
command! MR CtrlPMRUFiles

" Custom mapping
nnoremap <F5> <ESC>:so ~/.vimrc<CR>
