
set nocp
syntax on
set bs=2
set nu
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent
set incsearch
set t_Co=256
set background=dark
colorscheme molokai

call plug#begin('~/.vim/plugs')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'ycm-core/YouCompleteMe'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/DoxygenToolkit.vim'
call plug#end()

filetype on
let g:airline_symbols = {}
let g:airline_theme = "badwolf"
" powerline symbols
"
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


"允许加载 不再提示
let g:ycm_confirm_extra_conf = 0 
"关闭预览
set completeopt=menu
let g:ycm_error_symbol = '✗'
let g:ycm_warning_symbol = '✹'
let g:ycm_seed_identifiers_with_syntax = 1 
let g:ycm_complete_in_comments = 1 
let g:ycm_complete_in_strings = 1 
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_semantic_triggers =  { 
			\	'c' : ['.', '->', 're![_A-Za-z0-9]'], 
			\	'cpp' : ['.', '->','::', 're![_A-Za-z0-9]'] 
			\	}
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
map <F3> :NERDTreeToggle<cr>
nmap <cr> :call Run()<cr>
