" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

set number
let g:coc_disable_startup_warning = 1

map ,md :set nonumber spell autoindent linebreak tabstop=2<Enter>
map ,me :setlocal nonumber spell spelllang=es autoindent linebreak tabstop=2<Enter>
map ,mf :setlocal nonumber autoindent linebreak tabstop=2<Enter>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

let g:ale_linters = {
      \   'python': ['flake8', 'pylint'],
      \   'ruby': ['standardrb', 'rubocop'],
      \   'javascript': ['eslint'],
      \}

let g:ale_fixers = {
      \    'python': ['isort', 'yapf', 'black'],
      \}
nmap <F10> :ALEFix<CR>

imap <silent> <C-e> </<C-X><C-O><C-X><Esc>F<i
imap <silent> <C-b> <CR><C-o>O
imap <silent> <C-y> <C-e><C-b>


" let g:polyglot_disabled = ['python', 'python-indent']


call plug#begin('~/.vim/plugged')

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
" Plug 'Raimondi/delimitMate'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-syntastic/syntastic'
" Plug 'ervandew/supertab'

Plug 'rstacruz/vim-closer'

call plug#end()


" Enable cpp command for foothill cpp course
" autocmd Filetype cpp setlocal shiftwidth=3 softtabstop=3 expandtab
autocmd Filetype javascript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype yaml setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype html setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype css setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype json setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype javascript nnoremap ,kento :setlocal shiftwidth=4 softtabstop=4 expandtab<CR>
autocmd Filetype python nnoremap <buffer> <F5> :w<CR>:vert botright ter python3 "%"<CR>
autocmd Filetype python nnoremap <buffer> <F6> :w<CR>:vert botright ter powershell.exe -c python "%"<CR>
autocmd Filetype java setlocal shiftwidth=4 softtabstop=4 expandtab

