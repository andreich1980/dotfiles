syntax on

set number
set relativenumber

let mapleader = ' '
let maplocalleader = ' '

" Quit insert mode
inoremap jj <Esc>

" When text is wrapped, move by terminal rows, not lines, unless a count is provided
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Reselect visual selection after indenting
vnoremap > >gv
vnoremap < <gv

" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

" Paste replace visual selection without copying it
vnoremap p "_dP

nnoremap <Leader>k :nohlsearch<CR>

" Move text up and down
inoremap <A-j> <Esc>:move .+1<CR>==gi
inoremap <A-k> <Esc>:move .-2<CR>==gi
xnoremap <A-j> :move '>+1<CR>gv-gv
xnoremap <A-k> :move '<-2<CR>gv-gv

" Indentation settings
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smartindent

set nowrap

set number
set relativenumber

" Command-line completion mode
set wildmode=longest:full,full

" User interface settings
set title

" Enable mouse support in all modes
set mouse=a

" Enable true color support
set termguicolors

" Enable spell checking
set spell

" Search settings
set ignorecase
set smartcase        " Override ignorecase when search pattern has upper case

" Display settings
set list             " Show invisible characters
set listchars=tab:▸\ ,trail:·  " Show tabs and trailing spaces
set fillchars+=eob:\            " Hide ~ at end of buffer

" Scrolling settings
set scrolloff=5
set sidescrolloff=5

" Use system clipboard
set clipboard=unnamedplus

" Prompt instead of failing commands
set confirm

" File settings
set undofile         " Persistent undo
set backup           " Enable backup files
set backupdir-=.     " Don't store backups in current directory
