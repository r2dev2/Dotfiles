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

function! WatchForChanges(bufname, ...)
  " Figure out which options are in effect
  if a:bufname == '*'
    let id = 'WatchForChanges'.'AnyBuffer'
    " If you try to do checktime *, you'll get E93: More than one match for * is given
    let bufspec = ''
  else
    if bufnr(a:bufname) == -1
      echoerr "Buffer " . a:bufname . " doesn't exist"
      return
    end
    let id = 'WatchForChanges'.bufnr(a:bufname)
    let bufspec = a:bufname
  end
  if len(a:000) == 0
    let options = {}
  else
    if type(a:1) == type({})
      let options = a:1
    else
      echoerr "Argument must be a Dict"
    end
  end
  let autoread    = has_key(options, 'autoread')    ? options['autoread']    : 0
  let toggle      = has_key(options, 'toggle')      ? options['toggle']      : 0
  let disable     = has_key(options, 'disable')     ? options['disable']     : 0
  let more_events = has_key(options, 'more_events') ? options['more_events'] : 1
  let while_in_this_buffer_only = has_key(options, 'while_in_this_buffer_only') ? options['while_in_this_buffer_only'] : 0
  if while_in_this_buffer_only
    let event_bufspec = a:bufname
  else
    let event_bufspec = '*'
  end
  let reg_saved = @"
  "let autoread_saved = &autoread
  let msg = "\n"
  " Check to see if the autocommand already exists
  redir @"
    silent! exec 'au '.id
  redir END
  let l:defined = (@" !~ 'E216: No such group or event:')
  " If not yet defined...
  if !l:defined
    if l:autoread
      let msg = msg . 'Autoread enabled - '
      if a:bufname == '*'
        set autoread
      else
        setlocal autoread
      end
    end
    silent! exec 'augroup '.id
      if a:bufname != '*'
        "exec "au BufDelete    ".a:bufname . " :silent! au! ".id . " | silent! augroup! ".id
        "exec "au BufDelete    ".a:bufname . " :echomsg 'Removing autocommands for ".id."' | au! ".id . " | augroup! ".id
        exec "au BufDelete    ".a:bufname . " execute 'au! ".id."' | execute 'augroup! ".id."'"
      end
        exec "au BufEnter     ".event_bufspec . " :checktime ".bufspec
        exec "au CursorHold   ".event_bufspec . " :checktime ".bufspec
        exec "au CursorHoldI  ".event_bufspec . " :checktime ".bufspec
      " The following events might slow things down so we provide a way to disable them...
      " vim docs warn:
      "   Careful: Don't do anything that the user does
      "   not expect or that is slow.
      if more_events
        exec "au CursorMoved  ".event_bufspec . " :checktime ".bufspec
        exec "au CursorMovedI ".event_bufspec . " :checktime ".bufspec
      end
    augroup END
    let msg = msg . 'Now watching ' . bufspec . ' for external updates...'
  end
  " If they want to disable it, or it is defined and they want to toggle it,
  if l:disable || (l:toggle && l:defined)
    if l:autoread
      let msg = msg . 'Autoread disabled - '
      if a:bufname == '*'
        set noautoread
      else
        setlocal noautoread
      end
    end
    " Using an autogroup allows us to remove it easily with the following
    " command. If we do not use an autogroup, we cannot remove this
    " single :checktime command
    " augroup! checkforupdates
    silent! exec 'au! '.id
    silent! exec 'augroup! '.id
    let msg = msg . 'No longer watching ' . bufspec . ' for external updates.'
  elseif l:defined
    let msg = msg . 'Already watching ' . bufspec . ' for external updates'
  end
  let @"=reg_saved
endfunction

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

set number
let g:coc_disable_startup_warning = 1

map ,md :set nonumber spell autoindent linebreak tabstop=2<Enter>
map ,me :setlocal nonumber spell spelllang=es autoindent linebreak tabstop=2<Enter>
map ,mf :setlocal nonumber autoindent linebreak tabstop=2<Enter>

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

let g:ale_linters = {
      \   'python': ['flake8'],
      \   'ruby': ['standardrb', 'rubocop'],
      \   'javascript': ['eslint'],
      \}

let g:ale_fixers = {
      \    'python': ['isort', 'black'],
      \    'javascript': ['eslint'],
      \    'svelte': ['eslint'],
      \}

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

nmap <F10> :ALEFix<CR>

imap <silent> <C-e> </<C-X><C-O><C-X><Esc>F<i
imap <silent> <C-b> <CR><C-o>O
imap <silent> <C-y> <C-e><C-b>


" let g:polyglot_disabled = ['python', 'python-indent']

set visualbell
set t_vb=

call plug#begin('~/.vim/plugged')

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
" Plug 'Raimondi/delimitMate'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-syntastic/syntastic'
" Plug 'ervandew/supertab'

Plug 'rstacruz/vim-closer'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
" Plug 'codechips/coc-svelte', {'do': 'npm install'}

" Plug 'LucHermitte/lh-vim-lib'
" Plug 'LucHermitte/lh-tags'
" Plug 'LucHermitte/lh-dev'
" Plug 'LucHermitte/lh-style'
" Plug 'LucHermitte/lh-brackets'
" Plug 'LucHermitte/vim-refactor'
" Plug 'misterbuckley/vim-definitive'
" Plug 'elzr/vim-json'

Plug 'manicmaniac/coconut.vim'

call plug#end()

let autoreadargs={'autoread':1} 
execute WatchForChanges("*",autoreadargs) 

" au! BufNewFile,BufRead *.svelte set ft=html
autocmd BufNewFile,BufRead *.hy setlocal shiftwidth=4 softtabstop=4 expandtab

" Cpp convention for foothill cpp course
" autocmd Filetype cpp setlocal shiftwidth=3 softtabstop=3 expandtab
" C convention for julius codebase
autocmd Filetype c nnoremap ,julius :setlocal shiftwidth=2 softtabstop=2 expandtab<CR>

autocmd Filetype c setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd Filetype cpp setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd Filetype javascript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype svelte setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype yaml setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype html setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype css setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype json setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype javascript nnoremap ,kento :setlocal shiftwidth=4 softtabstop=4 expandtab<CR>
autocmd Filetype python nnoremap <buffer> <F5> :w<CR>:vert botright ter python3 "%"<CR>
autocmd Filetype python nnoremap <buffer> <F6> :w<CR>:vert botright ter powershell.exe -c python "%"<CR>
autocmd Filetype java setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd Filetype bash setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd Filetype sh setlocal shiftwidth=4 softtabstop=4 expandtab
