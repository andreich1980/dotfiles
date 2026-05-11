" --- General Settings ---
syntax on
set number
set relativenumber
set clipboard=unnamedplus,unnamed
set scrolloff=5
set sidescroll=10
set sidescrolloff=5

" Indentation settings
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smartindent
set nowrap

" Search settings
set ignorecase
set smartcase

" Display settings
set list
set listchars=tab:▸\ ,trail:·
set fillchars+=eob:\ 
set title
set termguicolors
set mouse=a

" File/Command settings
set wildmode=longest:full,full
set spell
set confirm
set undofile
set undodir=~/.vim/undo//
set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

" --- Mappings ---
let mapleader = " "
let maplocalleader = " "

" Easy exit insert mode
inoremap jj <Esc>

" When text is wrapped, move by terminal rows, not lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Selection with Shift + Arrows
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

" Indentation with Tab
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Reselect visual selection after indenting
vnoremap > >gv
vnoremap < <gv

" Maintain cursor position when yanking
vnoremap y myy`y
vnoremap Y myY`y

" Paste replace visual selection without copying it
vnoremap p "_dP

" Navigation & Config
nnoremap <leader>vv :e ~/.vimrc<CR>
nnoremap <leader>vr :source ~/.vimrc<CR>
nnoremap <Leader>k :nohlsearch<CR>

" Add , or ; at the end of the line
nnoremap <leader>, mzA,<Esc>`z
nnoremap <leader>; mzA;<Esc>`z

" Move text up and down
inoremap <A-j> <Esc>:move .+1<CR>==gi
inoremap <A-k> <Esc>:move .-2<CR>==gi
xnoremap <A-j> :move '>+1<CR>gv-gv
xnoremap <A-k> :move '<-2<CR>gv-gv

" IdeaVim specific (or other action-supporting plugins)
nmap gb <Action>(Back)
nmap gf <Action>(Forward)
