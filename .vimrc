"Note when ~/.vimrc present the following is done automatically
set nocompatible
set clipboard=unnamed

set wcm=<Tab>

menu Encoding.utf-8 :e ++enc=utf8<CR> ++ff=unix<CR>
menu Encoding.cp1251 :e ++enc=cp1251<CR> " ++ff=unix<CR>
menu Encoding.koi8-r :e ++enc=koi8-r<CR> " ++ff=unix<CR>
menu Encoding.cp866 :e ++enc=cp866<CR> " ++ff=dos<CR>
menu Encoding.koi8-u :e ++enc=koi8-u<CR> " ++ff=unix<CR>
map <F8> :emenu Encoding.<TAB>

set fileencodings=utf-8,cp1251,koi8-r,cp866,koi8-u

"Set terminal title to filename
set title

"if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
"    set fileencodings=utf-8,latin1
"endif

"set term=normal
"set gui=bold

if v:version >= 700
    "The following are a bit slow
    "for me to enable by default
    "set cursorline   "highlight current line
    "set cursorcolumn "highlight current column
    "set number
endif

"allow backspacing over everything in insert mode
set bs=2
set viminfo='5000,h
"set viminfo='20,\"500    " read/write a .viminfo file, don't store more
                        " than 50 lines of registers
set history=5000        " keep 5000 lines of command line history
"Allow switching buffers without writing to disk
set hidden
"Always show cursor position
set ruler
if has("autocmd")
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif
"This is necessary to allow pasting from outside vim. It turns off auto stuff.
"You can tell you are in paste mode when the ruler is not visible
set pastetoggle=<F2>
"Usually annoys me
"set nowrap
"Usually I don't care about case when searching
set ignorecase
"Only ignore case when we type lower case when searching
set smartcase
"I hate noise
"set visualbell
"Show menu with possible tab completions
set wildmenu
"Ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

""""""""""""""""""""""""""""""""""""""""""""""""
" Indenting
""""""""""""""""""""""""""""""""""""""""""""""""

"Default to autoindenting of C like languages
"This is overridden per filetype below
set noautoindent smartindent

"The rest deal with whitespace handling and
"mainly make sure hardtabs are never entered
"as their interpretation is too non standard in my experience
"set softtabstop=4
" Note if you don't set expandtab, vi will automatically merge
" runs of more than tabstop spaces into hardtabs. Clever but
" not what I usually want.
"set expandtab
"set shiftwidth=4
"set shiftround
"set nojoinspaces

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType groovy setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType cs setlocal ts=4 sts=4 sw=4 expandtab
au BufRead,BufNewFile *.hcl :set ts=2 sts=2 sw=2 expandtab syntax=terraform
au BufRead,BufNewFile Dockerfile* :set syntax=dockerfile
au BufRead,BufNewFile *.tsx :set syntax=typescript

""""""""""""""""""""""""""""""""""""""""""""""""
" Dark background
""""""""""""""""""""""""""""""""""""""""""""""""

"I always work on dark terminals
set background=dark

"Make the completion menus readable
highlight Pmenu ctermfg=0 ctermbg=3
highlight PmenuSel ctermfg=0 ctermbg=7

"The following should be done automatically for the default colour scheme
"at least, but it is not in Vim 7.0.17.
if &bg == "dark"
  highlight MatchParen ctermbg=darkblue guibg=blue
endif

""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax highlighting
""""""""""""""""""""""""""""""""""""""""""""""""

"Syntax highlighting if appropriate
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
    set incsearch "For fast terminals can highlight search string as you type
endif

if &diff
    "I'm only interested in diff colours
    syntax off
endif

"syntax highlight shell scripts as per POSIX,
"not the original Bourne shell which very few use
let g:is_posix = 1

"flag problematic whitespace (trailing and spaces before tabs)
"Note you get the same by doing let c_space_errors=1 but
"this rule really applys to everything.
highlight RedundantSpaces term=standout ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted
"use :set list! to toggle visible whitespace on/off
set listchars=tab:>-,trail:.,extends:>

""""""""""""""""""""""""""""""""""""""""""""""""
" Key bindings
""""""""""""""""""""""""""""""""""""""""""""""""

"Note <leader> is the user modifier key (like g is the vim modifier key)
"One can change it from the default of \ using: let mapleader = ","

"\n to turn off search highlighting
nmap <silent> <leader>n :silent :nohlsearch<CR>
"\l to toggle visible whitespace
nmap <silent> <leader>l :set list!<CR>
"Shift-tab to insert a hard tab
imap <silent> <S-tab> <C-v><tab>

"allow deleting selection without updating the clipboard (yank buffer)
vnoremap x "_x
vnoremap X "_X

"<home> toggles between start of line and start of text
imap <khome> <home>
nmap <khome> <home>
inoremap <silent> <home> <C-O>:call Home()<CR>
nnoremap <silent> <home> :call Home()<CR>
function Home()
    let curcol = wincol()
    normal ^
    let newcol = wincol()
    if newcol == curcol
        normal 0
    endif
endfunction

"<end> goes to end of screen before end of line
imap <kend> <end>
nmap <kend> <end>
inoremap <silent> <end> <C-O>:call End()<CR>
nnoremap <silent> <end> :call End()<CR>
function End()
    let curcol = wincol()
    normal g$
    let newcol = wincol()
    if newcol == curcol
        normal $
    endif
    "The following is to work around issue for insert mode only.
    "normal g$ doesn't go to pos after last char when appropriate.
    "More details and patch here:
    "http://www.pixelbeat.org/patches/vim-7.0023-eol.diff
    if virtcol(".") == virtcol("$") - 1
        normal $
    endif
endfunction

"Ctrl-{up,down} to scroll.
"The following only works in gvim?
"Also vim doesn't have default C-{home,end} bindings?
if has("gui_running")
    nmap <C-up> <C-y>
    imap <C-up> <C-o><C-y>
    nmap <C-down> <C-e>
    imap <C-down> <C-o><C-e>
endif

""""""""""""""""""""""""""""""""""""""""""""""""
" file type handling
""""""""""""""""""""""""""""""""""""""""""""""""

" To create new file securely do: vim new.file.txt.gpg
" Your private key used to decrypt the text before viewing should
" be protected by a passphrase. Alternatively one could use
" a passphrase directly with symmetric encryption in the gpg commands below.
au BufNewFile,BufReadPre *.gpg :set secure viminfo= noswapfile nobackup nowritebackup history=0 binary
au BufReadPost *.gpg :%!gpg -d 2>/dev/null
au BufWritePost *.gpg u
"
"local syntax
au BufRead,BufNewFile .bash_local* :set ft=sh
au BufRead,BufNewFile */etc/nginx/* :set ft=nginx
au BufRead,BufNewFile */etc/named.conf* :set ft=named
au BufRead,BufNewFile *.jsm :set ft=javascript

filetype on
filetype plugin on
filetype indent on

augroup sh
    au!
    "smart indent really only for C like languages
    au FileType sh set nosmartindent autoindent
augroup END

augroup Python
    "See $VIMRUNTIME/ftplugin/python.vim
    au!
    "smart indent really only for C like languages
    "See $VIMRUNTIME/indent/python.vim
    au FileType python set nosmartindent autoindent
    " Allow gf command to open files in $PYTHONPATH
    au FileType python let &path = &path . "," . substitute($PYTHONPATH, ';', ',', 'g')
    if v:version >= 700
        "See $VIMRUNTIME/autoload/pythoncomplete.vim
        "<C-x><C-o> to autocomplete
        au FileType python set omnifunc=pythoncomplete#Complete
        "Don't show docs in preview window
        au FileType python set completeopt-=preview
    endif
augroup END

