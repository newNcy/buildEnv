
set nocp
syntax on
set bs=2
set nu
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set expandtab
set cindent
set incsearch
set hlsearch
set t_Co=256
set autoread
set autowrite
set background=dark
set wildmenu
let g:solarized_termcolors=256
"colorscheme solarized

"call plug#begin('~/.vim/plugs')
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'mhinz/vim-startify'
"Plug 'ryanoasis/vim-devicons'
"Plug 'ycm-core/YouCompleteMe'
"Plug 'scrooloose/nerdtree'
"Plug 'vim-scripts/DoxygenToolkit.vim'
"Plug 'joshdick/onedark.vim'
"call plug#end()

let g:NERDTreeDirArrowExpandable='▷'
let g:NERDTreeDirArrowCollapsible='▼'

filetype on
let g:airline_symbols = {}
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

let g:target = ""
func! Run()
	exec "w"
	if filereadable("Makefile")
		exec "!make"
	elseif &filetype == 'c'
		exec "!gcc -g % -o %< -std=c99"
		let g:target = expand("%<")
	elseif &filetype == 'cpp'
		exec "!g++ -g % -o %<"
		let g:target = expand("%<")
	else 
		return
	endif
	if g:target == ""
		let g:target = input("target = ")
	else 
		if filereadable("./" . g:target)
			exec "!./" . g:target
		endif
	endif
endfunc

func! GenImpl()
	"检测是否为头文件
	let path = expand("%")
	let _ft = strpart(path, stridx(path,"/"))
	let ft = strpart(_ft, stridx(_ft, ".") + 1)
	if ft != 'h'
		echo expand("%") . " is not header file"
		return
	endif

	call cursor([1,1])
	let flag = "Wz"
	let class_name_regex = "\\(\\<class\\ *\\w*\\)\\zs\\<\\w*\\>"
	let decl_regex = "\\S.*\(.*\).*\\(;\\)\\@="
	let virt_decl_regex = ".*=.*"
	let func_name_regex = "\\S\\+\\(\ *\(.*\)\\)\\@="

	let c = search(class_name_regex, flag)
	let old_pos = getcurpos()
	let next_c = search(class_name_regex, flag)
	call cursor(old_pos[1:])

	if !c 
		echo "no class found"
		return
	endif

	let impls = []
	while 1 
		let decl = search(decl_regex, flag)
		if !decl
			break
		elseif next_c && decl > next_c
			let c = next_c
			let old_pos = getcurpos()
			let next_c = search(class_name_regex, flag)
			call cursor(old_pos[1:])
		endif
		let sig = matchstr(getline(decl), decl_regex)
		if match(sig, virt_decl_regex) != -1 
			continue
		endif
		let class_name = matchstr(getline(c), class_name_regex) 

		let func_name_start = match(sig, func_name_regex)
		let func_name = matchstr(sig, func_name_regex)
		
		let spec = strcharpart(sig, 0, func_name_start)
		let postfix = strcharpart(sig, func_name_start + strchars(func_name))
		
		let full_sig = spec . class_name . "::" . func_name . postfix 
		call add(impls , full_sig)
	endwhile
	"写入cpp	
	let impl_file_name = expand("%<") . ".cpp"
	if filereadable(impl_file_name) 
		echo impl_file_name . " exists"
		return
	endif
	let header = expand("%")
	exec "vs " . impl_file_name
	let l = getcurpos()[1]
	call setline(l, "#include \"". header . "\"")
	let l += 1
	call setline(l, "")
	let l += 1
	for sig in impls
		call setline(l, sig)
		let l += 1
		call setline(l, "{}")
		let l += 1
		call setline(l, "")
		let l += 1
	endfor
endfunc


func! OpenHOrCpp()
	let path = expand("%")
	let _ft = strpart(path, stridx(path,"/"))
	let ft = strpart(_ft, stridx(_ft, ".") + 1)
	let f = ""
	if ft == "cpp" || ft == "cc" || ft == "c"
		let f = expand("%<") . ".h"
	elseif ft == "h"
		if filereadable(expand("%<") . ".c")
			let f = expand("%<") . ".c"
		elseif filereadable(expand("%<") . ".cc")
			let f = expand("%<") . ".cc"
		elseif filereadable(expand("%<") . ".cpp")
			let f = expand("%<") . ".cpp"
		endif
	else
		echo expand("%") . "不是c/c++文件!"
		return
	endif

	if f == "" || !filereadable(f)
		echo f . " 不存在！"
	else 
		exec "vs " . f
	endif
endfunc

"tab切换到下一个tab
map <tab> :w<cr><c-w><c-w>

"空格新建tab
nmap <space> :tabnew 
"f3打开文件目录树
map <F3> :NERDTreeToggle<cr>

nmap <F4> :let g:target = input("target = ")<cr>
"回车运行
nmap <cr> :call Run()<cr>


map <F8> :call OpenHOrCpp()<cr>
map <F7> :call GenImpl()<cr>
nmap <s-h> gT
nmap <s-l> gt
