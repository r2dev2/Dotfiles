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

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

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

let g:vim_svelte_plugin_use_typescript = 1

let g:user_emmet_leader_key='<C-z>'
imap <silent> <C-y> <C-z>,

nmap <F10> :ALEFix<CR>

" imap <silent> <C-e> </<C-X><C-O><C-X><Esc>F<i
" imap <silent> <C-b> <CR><C-o>O
" imap <silent> <C-y> <C-e><C-b>


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

Plug 'mattn/emmet-vim'

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
Plug 'hylang/hy'

call plug#end()

let autoreadargs={'autoread':1} 
execute WatchForChanges("*",autoreadargs) 

set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam,*.exe

" au! BufNewFile,BufRead *.svelte set ft=html
autocmd BufNewFile,BufRead *.hy setlocal shiftwidth=4 softtabstop=4 expandtab

" Use MASM for x86 De Anza course
autocmd BufNewFile,BufRead *.asm setlocal ft=masm

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
autocmd Filetype markdown map j gj
autocmd Filetype markdown map k gk
autocmd Filetype markdown setlocal nonumber autoindent linebreak tabstop=2
