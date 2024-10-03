" Get vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    au VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'cocopon/iceberg.vim'
Plug 'gkeep/iceberg-dark'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rhysd/vim-clang-format'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" Tabs
set tabstop=4           " Set number of spaces to display for <Tab>
set shiftwidth=4        " Set number of spaces for a shift operation (>> or <<) 
set expandtab           " Expand <Tab>s to spaces
set autoindent          " Indent next line as same as current line
set smartindent         " Use code syntax/style to align  
filetype plugin indent on
" https://stackoverflow.com/questions/11984520/vim-indent-align-function-arguments
au FileType c,cpp set cindent cinoptions=(0,u0,U0,(0 cinwords+=for,if
au FileType c,cpp set tabstop=4 shiftwidth=4 softtabstop=4
au FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
au FileType markdown set softtabstop=4 noexpandtab

" Folding 
au BufRead * normal zR
set foldnestmax=10
set foldlevel=0
set foldmethod=syntax
au FileType python set foldmethod=indent

" General settings 
colorscheme iceberg
set background="dark"
syntax on
let mapleader = " "
let maplocalleader=","
set showmode showcmd
set showmatch           " highlight matching [], {}, () 
set hlsearch            " highlight searches
set incsearch           " search as you type 
set colorcolumn=80
set textwidth=80
set wrapmargin=2
" Preserve last editing position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
set number
set clipboard=unnamed   " unnamedplus for linux
set cursorline
au BufReadPost *bash* set syntax=sh
set encoding=utf-8
set nobackup
set autochdir           " Automatically change working directory 
set backspace=indent,eol,start
" autoread: https://stackoverflow.com/a/20418591
au FocusGained,BufEnter * :silent! !
" paste below current line
nmap <leader>p o<ESC>p

" Persistent_undo: https://stackoverflow.com/a/22676189
if has('persistent_undo')
    let target_path = expand('/tmp/.vim-undo-dir') " ~/.config/undo/') 
    if has('nvim')
        let target_path = expand('~/.config/undo/')
    endif
    if !isdirectory(target_path)
        call mkdir(target_path, "", 0700)
    endif
    let &undodir = target_path 
    set undofile
endif

" 
" Plugin settings
"

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction



" lightline
set laststatus=2        " Permanent status bar; also makes lightline work
set noshowmode          " Because lightline
let g:lightline = {
            \ 'colorscheme': 'deus',
            \ }
" Reduce lag switching to normal mode: https://github.com/itchyny/lightline.vim/issues/389
set ttimeout ttimeoutlen=50

" clang-format
let g:clang_format#style_options = {
            \ "Language" : "Cpp",
            \ "Standard" : "C++11",
            \ "BasedOnStyle" : "Google",
            \ "AllowShortIfStatementsOnASingleLine" : "false",
            \ "AllowShortLoopsOnASingleLine" : "false",
            \ "ReflowComments" : "true"}
au FileType cpp noremap <Leader>f :ClangFormat<CR>

" Remove trailing whitespaces
" https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
" Equivalent to %s/\s\+$//ge
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
noremap <Leader>W :call TrimWhitespace()<CR>
au BufWritePre *.c,*.cc,*.cpp call TrimWhitespace()

" https://github.com/git-time-metric/gtm-vim-plugin
" In the status bar see your total time spent for in-process work (uncommitted).
let g:gtm_plugin_status_enabled = 1

function! AirlineInit()
  if exists('*GTMStatusline')
    call airline#parts#define_function('gtmstatus', 'GTMStatusline')
    let g:airline_section_b = airline#section#create([g:airline_section_b, ' ', '[', 'gtmstatus', ']'])
  endif
endfunction
autocmd User AirlineAfterInit call AirlineInit()

" Switch between panes easier
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

au FileType *.pl set syntax prolog
