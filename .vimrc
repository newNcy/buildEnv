
set nocp
syntax on
filetype on
set bs=2
set nu
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent

set t_Co=256
syntax enable
set background=dark
colorscheme molokai
call plug#begin('~/.vim/plugs')
Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'mhinz/vim-startify'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/DoxygenToolkit.vim'
call plug#end()

let g:airline_symbols = {}
let g:airline_theme = "badwolf"
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#right_sep = ''

function! ChangyinN()
	let keys = ['C','h','a','n','g','y','i','n', 'N', '|' ,'mode']
	for k in keys
		call airline#parts#define_text(k, k)
	endfor
	call airline#parts#define_accent('C', 'red')
	call airline#parts#define_accent('h', 'green')
	call airline#parts#define_accent('a', 'blue')
	call airline#parts#define_accent('n', 'green')
	call airline#parts#define_accent('g', 'orange')
	call airline#parts#define_accent('y', 'purple')
	call airline#parts#define_accent('N', 'red')
	let g:airline_section_a = airline#section#create(keys)
endfunction
autocmd VimEnter * call ChangyinN()

func! Run()
	exec "w"
	if &filetype == 'c'
		echo "run gcc..."
		exec "!gcc -g % -o %<"
	elseif &filetype == 'cpp'
		echo "run g++..."
		exec "!g++ -g % -o %<"
	endif
	exec "!./%<"
endfunc

map <tab> :w<cr>:tabn<cr>
nmap <space> :tabnew 
nmap <cr> :call Run()<cr>
