" let g:no_autochdir=1
" let g:no_restore_cursor=1
" let g:override_bundles=1
" let g:keep_trailing_whitespace = 1
" let g:no_easyWindows = 1
" let g:no_fastTabs = 1
" let g:clear_search_highlight = 1
" let g:no_omni_complete=1
let g:bundle_groups=['go', 'general', 'writing', 'neocomplete', 'programming', 'python', 'javascript', 'html']

set nocompatible        " Must be first line

" plugins settings
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
function! UnBundle(arg, ...)
    let bundle = vundle#config#init_bundle(a:arg, a:000)
    call filter(g:vundle#bundles, 'v:val["name_spec"] != "' . a:arg . '"')
endfunction

com! -nargs=+         UnBundle
            \ call UnBundle(<args>)


Bundle 'gmarik/vundle'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
if executable('ag')
    Bundle 'mileszs/ack.vim'
    let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
elseif executable('ack-grep')
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
    Bundle 'mileszs/ack.vim'
elseif executable('ack')
    Bundle 'mileszs/ack.vim'
endif

if count(g:bundle_groups, 'general')
    Bundle 'scrooloose/nerdtree'
    Bundle 'tpope/vim-surround'
    Bundle 'tpope/vim-repeat'
    Bundle 'rhysd/conflict-marker.vim'
    Bundle 'jiangmiao/auto-pairs'
    Bundle 'ctrlpvim/ctrlp.vim'
    Bundle 'tacahiroy/ctrlp-funky'
    Bundle 'terryma/vim-multiple-cursors'
    Bundle 'vim-scripts/sessionman.vim'
    Bundle 'bling/vim-bufferline'
    Bundle 'easymotion/vim-easymotion'
    Bundle 'jistr/vim-nerdtree-tabs'
    Bundle 'mbbill/undotree'
    Bundle 'nathanaelkane/vim-indent-guides'
"    Bundle 'mhinz/vim-signify'
    Bundle 'tpope/vim-abolish.git'
    Bundle 'osyo-manga/vim-over'
    Bundle 'kana/vim-textobj-user'
    Bundle 'kana/vim-textobj-indent'
    Bundle 'gcmt/wildfire.vim'
endif

if count(g:bundle_groups, 'writing')
    Bundle 'reedes/vim-litecorrect'
    Bundle 'reedes/vim-textobj-sentence'
    Bundle 'reedes/vim-textobj-quote'
    Bundle 'reedes/vim-wordy'
    Bundle 'tpope/vim-markdown'
    Bundle 'spf13/vim-preview'
endif

if count(g:bundle_groups, 'programming')
    " Pick one of the checksyntax, jslint, or syntastic
    Bundle 'scrooloose/syntastic'
    Bundle 'tpope/vim-fugitive'
 "   Bundle 'mattn/webapi-vim'
    Bundle 'mattn/gist-vim'
    Bundle 'scrooloose/nerdcommenter'
    Bundle 'tpope/vim-commentary'
    Bundle 'godlygeek/tabular'
    Bundle 'luochen1990/rainbow'
    if executable('ctags')
        Bundle 'majutsushi/tagbar'
    endif
endif

if count(g:bundle_groups, 'neocomplete')
    Bundle 'Shougo/neocomplete.vim.git'
    Bundle 'Shougo/neosnippet'
    Bundle 'Shougo/neosnippet-snippets'
    Bundle 'honza/vim-snippets'
endif

if count(g:bundle_groups, 'python')
    " Pick either python-mode or pyflakes & pydoc
    Bundle 'klen/python-mode'
    Bundle 'yssource/python.vim'
    Bundle 'python_match.vim'
    Bundle 'pythoncomplete'
endif

if count(g:bundle_groups, 'javascript')
    Bundle 'elzr/vim-json'
    Bundle 'groenewege/vim-less'
    Bundle 'pangloss/vim-javascript'
    Bundle 'briancollins/vim-jst'
"    Bundle 'kchmck/vim-coffee-script'
endif

if count(g:bundle_groups, 'html')
    Bundle 'amirh/HTML-AutoCloseTag'
    Bundle 'hail2u/vim-css3-syntax'
    Bundle 'gorodinskiy/vim-coloresque'
    Bundle 'tpope/vim-haml'
    Bundle 'mattn/emmet-vim'
endif

if count(g:bundle_groups, 'go')
    "Bundle 'Blackrush/vim-gocode'
    Bundle 'fatih/vim-go'
endif

set paste
filetype pluginindent on   " Automatically detect file types.
syntax on                   " Syntax highlighting
set mouse=i                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing
" Let Vim use utf-8 internally, because many scripts require this
set encoding=utf-8
setglobal fileencoding=utf-8
scriptencoding utf-8

if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

" Most prefer to automatically switch to the current file directory when a new buffer is opened
if !exists('g:no_autochdir')
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    " Always switch to the current file directory
endif

set autowrite                       " Automatically write a file when leaving a modified buffer
set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set virtualedit=onemore             " Allow for cursor beyond last character
set history=1000                    " Store a ton of history (default is 20)
"set spell                           " Spell checking on
set hidden                          " Allow buffer switching without saving
set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-                    " '-' is an end of word designator

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
if !exists('g:no_restore_cursor')
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END
endif

set backup                  " Backups are nice ...
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode
"set cursorline                  " Highlight current line
highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
"highlight clear CursorLineNr    " Remove highlight color from current line number

if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
    " Selected characters/lines in visual mode
endif

if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    if !exists('g:override_bundles')
        set statusline+=%{fugitive#statusline()} " Git Hotness
    endif
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

set wrap                        " wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
"set matchpairs+=<:>             " Match, to be used with %
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

" Remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
" autocmd FileType go autocmd BufWritePre <buffer> Fmt

let mapleader = ','
let maplocalleader = '_'

" Easier moving in tabs and windows
" The lines conflict with the default digraph mapping of <C-K>
" If you prefer that functionality, add the following to your
" let g:no_easyWindows = 1
if !exists('g:no_easyWindows')
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_
endif

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" The following two lines conflict with moving to top and
" bottom of the screen
if !exists('g:no_fastTabs')
    map <S-H> gT
    map <S-L> gt
endif

" Stupid shift key fixes
if !exists('g:no_keyfixes')
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    cmap Tabe tabe
endif

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Code folding options
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

" Most prefer to toggle search highlighting rather than clear the current
" search results.
if exists('g:clear_search_highlight')
    nmap <silent> <leader>/ :nohlsearch<CR>
else
    nmap <silent> <leader>/ :set invhlsearch<CR>
endif


" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" Shortcuts
" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Adjust viewports to the same size
map <Leader>= <C-w>=

"Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Easier horizontal scrolling
map zl zL
map zh zH

" Easier formatting
nnoremap <silent> <leader>q gwip

" FIXME: Revert this f70be548
" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>


" plugins
if count(g:bundle_groups, 'go')
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    let g:go_fmt_command = "goimports"
    let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
    let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
    au FileType go nmap <Leader>s <Plug>(go-implements)
    au FileType go nmap <Leader>i <Plug>(go-info)
    au FileType go nmap <Leader>e <Plug>(go-rename)
    au FileType go nmap <leader>r <Plug>(go-run)
    au FileType go nmap <leader>b <Plug>(go-build)
    au FileType go nmap <leader>t <Plug>(go-test)
    au FileType go nmap <Leader>gd <Plug>(go-doc)
    au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
    au FileType go nmap <leader>co <Plug>(go-coverage)
endif

if count(g:bundle_groups, 'writing')
    augroup textobj_sentence
        autocmd!
        autocmd FileType markdown call textobj#sentence#init()
        autocmd FileType textile call textobj#sentence#init()
        autocmd FileType text call textobj#sentence#init()
    augroup END
    augroup textobj_quote
        autocmd!
        autocmd FileType markdown call textobj#quote#init()
        autocmd FileType textile call textobj#quote#init()
        autocmd FileType text call textobj#quote#init({'educate': 0})
    augroup END
endif

if isdirectory(expand("~/.vim/bundle/nerdtree"))
    let g:NERDShutUp=1
endif
if isdirectory(expand("~/.vim/bundle/matchit.zip"))
    let b:match_ignorecase = 1
endif

if !exists('g:no_omni_complete')
    if has("autocmd") && exists("+omnifunc")
        autocmd Filetype *
                    \if &omnifunc == "" |
                    \setlocal omnifunc=syntaxcomplete#Complete |
                    \endif
    endif

    hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
    hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
    hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

    " Some convenient mappings
    "inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
    if exists('g:map_cr_omni_complete')
        inoremap <expr> <CR>     pumvisible() ? "\<C-y>" : "\<CR>"
    endif
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

    " Automatically open and close the popup menu / preview window
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    set completeopt=menu,preview,longest
endif

set tags=./tags;/,~/.vimtags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif

if isdirectory(expand("~/.vim/bundle/nerdtree"))
    map <C-e> <plug>NERDTreeTabsToggle<CR>
    map <leader>e :NERDTreeFind<CR>
    nmap <leader>nt :NERDTreeFind<CR>

    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    let NERDTreeChDirMode=0
    let NERDTreeQuitOnOpen=1
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=1
    let g:nerdtree_tabs_open_on_gui_startup=0
endif

if isdirectory(expand("~/.vim/bundle/tabular"))
    nmap <Leader>a& :Tabularize /&<CR>
    vmap <Leader>a& :Tabularize /&<CR>
    nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    nmap <Leader>a=> :Tabularize /=><CR>
    vmap <Leader>a=> :Tabularize /=><CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a,, :Tabularize /,\zs<CR>
    vmap <Leader>a,, :Tabularize /,\zs<CR>
    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
endif

if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
    let g:ctrlp_working_path_mode = 'ra'
    nnoremap <silent> <D-t> :CtrlP<CR>
    nnoremap <silent> <D-r> :CtrlPMRU<CR>
    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

    if executable('ag')
        let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
    elseif executable('ack-grep')
        let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
    elseif executable('ack')
        let s:ctrlp_fallback = 'ack %s --nocolor -f'
        " On Windows use "dir" as fallback command.
    elseif WINDOWS()
        let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
    else
        let s:ctrlp_fallback = 'find %s -type f'
    endif
    if exists("g:ctrlp_user_command")
        unlet g:ctrlp_user_command
    endif
    let g:ctrlp_user_command = {
                \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
                \ }

    if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
        " CtrlP extensions
        let g:ctrlp_extensions = ['funky']

        "funky
        nnoremap <Leader>fu :CtrlPFunky<Cr>
    endif
endif

if isdirectory(expand("~/.vim/bundle/tagbar/"))
    nnoremap <silent> <leader>tt :TagbarToggle<CR>
endif

if isdirectory(expand("~/.vim/bundle/rainbow/"))
    let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
endif

if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
endif

if count(g:bundle_groups, 'neocomplete')
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#max_list = 15
    let g:neocomplete#force_overwrite_completefunc = 1


    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'
    if !exists('g:no_neosnippet_expand')
        imap <C-k> <Plug>(neosnippet_expand_or_jump)
        smap <C-k> <Plug>(neosnippet_expand_or_jump)
    endif
    if exists('g:noninvasive_completion')
        inoremap <CR> <CR>
        " <ESC> takes you out of insert mode
        inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
        " <CR> accepts first, then sends the <CR>
        inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
        " <Down> and <Up> cycle like <Tab> and <S-Tab>
        inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
        " Jump up and down the list
        inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
    else
        " <C-k> Complete Snippet
        " <C-k> Jump to next snippet point
        imap <silent><expr><C-k> neosnippet#expandable() ?
                    \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                    \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
        smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

        inoremap <expr><C-g> neocomplete#undo_completion()
        inoremap <expr><C-l> neocomplete#complete_common_string()
        "inoremap <expr><CR> neocomplete#complete_common_string()
        " <CR>: close popup
        " <s-CR>: close popup and save indent.
        inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()."\<CR>" : "\<CR>"

        function! CleverCr()
            if pumvisible()
                if neosnippet#expandable()
                    let exp = "\<Plug>(neosnippet_expand)"
                    return exp . neocomplete#smart_close_popup()
                else
                    return neocomplete#smart_close_popup()
                endif
            else
                return "\<CR>"
            endif
        endfunction

        " <CR> close popup and save indent or expand snippet
        imap <expr> <CR> CleverCr()
        " <C-h>, <BS>: close popup and delete backword char.
        inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><C-y> neocomplete#smart_close_popup()
    endif
    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

    " Courtesy of Matteo Cavalleri

    function! CleverTab()
        if pumvisible()
            return "\<C-n>"
        endif
        let substr = strpart(getline('.'), 0, col('.') - 1)
        let substr = matchstr(substr, '[^ \t]*$')
        if strlen(substr) == 0
            " nothing to match on empty string
            return "\<Tab>"
        else
            " existing text matching
            if neosnippet#expandable_or_jumpable()
                return "\<Plug>(neosnippet_expand_or_jump)"
            else
                return neocomplete#start_manual_complete()
            endif
        endif
    endfunction

    imap <expr> <Tab> CleverTab()
    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
endif

if count(g:bundle_groups, 'neocomplete')
    " Use honza's snippets.
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

    " Enable neosnippet snipmate compatibility mode
    let g:neosnippet#enable_snipmate_compatibility = 1

    " For snippet_complete marker.
    if !exists("g:no_conceal")
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif
    endif

    " Enable neosnippets when using go
    let g:go_snippet_engine = "neosnippet"

    " Disable the neosnippet preview candidate window
    " When enabled, there can be too much visual noise
    " especially when splits are used.
    set completeopt-=preview
endif

if isdirectory(expand("~/.vim/bundle/undotree/"))
    nnoremap <Leader>u :UndotreeToggle<CR>
    " If undotree is opened, it is likely one wants to interact with it.
    let g:undotree_SetFocusWhenToggle=1
endif

let g:wildfire_objects = {
            \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
            \ "html,xml" : ["at"],
            \ }






" functions
" Strip whitespace
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

function! s:RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
endfunction

command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
