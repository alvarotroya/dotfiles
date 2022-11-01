if ! filereadable(expand('~/.vim/autoload/plug.vim'))
     silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
     autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" ==== PLUGINS ====
Plug 'scrooloose/nerdtree'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/syntastic'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
Plug 'morhetz/gruvbox'
" ==== END PLUGINS ====
call plug#end()

filetype plugin indent on

" ==== BASIC ====
let mapleader = " "
colorscheme gruvbox
set guifont=Monospace\ 11
set fillchars+=vert:\$
syntax enable
set background=dark
set ruler
set hidden
set relativenumber
set number
set laststatus=2
"set smartindent
set autoindent
set cindent
"set st=4 sw=4 et
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" ==== CtrlP ====
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|mp3|pdf|jpg|png|tar|deb|mp4)$'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_open_multiple_files = '10'

" ==== NERDTREE ====
let NERDTreeIgnore = ['\.pyc$', '\.o$', '\.so$', '\.a$', '[a-zA-Z]*egg[a-zA-Z]*', '[a-zA-Z]*cache[a-zA-Z]*']
let g:NERDTreeWinPos="left"
let g:NERDTreeDirArrows=0
map <C-t> :NERDTreeToggle<CR>

" ==== Syntastic ====
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"set to 1 to enable syntax check on opening
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_mri_args = "--config=$HOME/.jshintrc"
let g:syntastic_python_checkers = [ 'pylint', 'flake8', 'pep8', 'pyflakes', 'python']
let g:syntastic_yaml_checkers = ['jsyaml']
let g:syntastic_html_tidy_exec = 'tidy5'
let g:syntastic_tex_checkers = ['lacheck', 'text/language_check']
let g:syntastic_cpp_checkers = ['clang_check']
let g:syntastic_cpp_compiler = "clang++"
let g:syntastic_cpp_compiler_options = "-Weverything -Wno-c++98-compat -g -std=c++11"
let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["tex"] }

" ==== Airline ====
let g:airline_theme='luna'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

" ==== vimtex ====
let g:vimtex_version_check = 0
let g:vimtex_view_method='zathura'
let g:vimtex_compiler_engine='pdflatex -synctex=1'
"let g:vimtex_compiler_engine='xelatex -synctex=1 -interaction=nonstopmode'

" ==== Easymotion ====
let g:EasyMotion_do_mapping = 1
let g:EasyMotion_smartcase = 1
nmap <Leader>f <Plug>(easymotion-bd-f)
"nmap f <Plug>(easymotion-bd-f)
"nmap <Leader>f <Plug>(easymotion-bd-fn)
nmap <Leader>s <Plug>(easymotion-bd-f2)

"makes ?mapleader work as trigger
map <Leader> <Plug>(easymotion-prefix) 

"Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
map  <Leader>W <Plug>(easymotion-bd-W)

"n character search
map <Leader>/ <Plug>(easymotion-sn)
omap <Leader>/ <Plug>(easymotion-tn)

map <Leader>l <Plug>(easymotion-fl)
map <Leader>j <Plug>(easymotion-f)
map <Leader>k <Plug>(easymotion-F)
map <Leader>h <Plug>(easymotion-Fl)
"let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" ==== Markdown-Preview.Vim ====
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_browser = ''
let g:mkdp_echo_preview_url = 0
" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {}
    \ }
" use a custom port to start server or random for empty
let g:mkdp_port = ''
" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'
" use a custom markdown and highlighting style (must be absolute path)
let g:mkdp_markdown_css = '/home/alvaro-uni/repos/markdown-css/retro.css'
let g:mkdp_highlight_css = ''

" ==== Window navigation ====
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Make VIM remember position in file after reopen
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Set X11 clipboard to default clipboard
set clipboard=unnamedplus

" Highlight search results
set hlsearch

"Highlight matching brackets
set showmatch

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"Change pwd to the current file automatically
set autochdir

" Linebreak on 1000 characters
set lbr
set tw=1000

"set ai "Auto indent
"set si "Smart indent
set wrap "Wrap lines

"double scape to save
map <Esc><Esc> :w<CR>

"spell checking shortcut
map <F6> <esc>:setlocal spell! spelllang=de_de<CR>
"map <F6> <esc>:setlocal spell! spelllang=en_gb<CR>

"nmap <C-o> <Nop>
map <F2> :so $MYVIMRC<CR>

"save shortcut
nmap <C-s> :w<CR>
imap <C-s> <esc>:w<CR>

"quick buffer switching
nnoremap  <silent>   <tab>  :bnext<CR>
nnoremap  <silent> <s-tab>  :bprevious<CR>

" Add more delimiter with corresponding text object actions
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%' ]
  execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
  execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
  execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

"Navigating with guides
inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
vnoremap <Space><Space> <Esc>/<++><Enter>"_c4l
map <Space><Space> <Esc>/<++><Enter>"_c4l
inoremap ;gui <++>
