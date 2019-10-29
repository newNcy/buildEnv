#!/bin/bash

cd 
echo "install env for $USER[Y/n]?"

#git
sudo yum install git

function install_zsh()
{
	sudo yum install zsh
	chsh $USER -s /bin/zsh
	git clone https://github.com/robbyrussell/oh-my-zsh
	cd oh-my-zsh
	chmod +x tools/install.sh
	./tools/install.sh
	cd
}



#vim
function install_vim()
{
	git clone https://github.com/vim/vim.git
	cd ./vim
	sudo yum install gcc gcc-c++
	sudo yum install pythton3
	sudo yum install python3-devel.x86_64
	sudo yum install python-devel.x86_64
	sudo yum install -y ruby ruby-devel lua lua-devel luajit \
		luajit-devel ctags git \
		perl perl-devel perl-ExtUtils-ParseXS \
		perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
		perl-ExtUtils-Embed libX11-devel ncurses-devel

	./configure --with-features=huge \
		--enable-multibyte \
		--enable-rubyinterp=yes \
		--enable-python3interp=yes \
		--with-python-config-dir=/lib64/python3.6/config-3.6m-x86_64-linux-gnu  \
		--enable-perlinterp=yes \
		--enable-luainterp=yes \
		--enable-gui=gtk2 \
		--enable-cscope \
		--prefix=/usr/local

	make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
	sudo make install
	cd

	
	#复制配置
	git clone https://github.com/newNcy/buildEnv
	cp buildEnv/.vimrc ~/
	#ycm先装，因为装了插件会卡住
	mkdir -p ~/.vim/plugs
	cd ~/.vim/plugs
	git clone https://github.com/ycm-core/YouCompleteMe
	cd YouCompleteMe
	git submodule update --init --recursive

	#手动下载防止卡住
	mkdir -p ~/.vim/plugs/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
	cp ~/buildEnv/clangd-9.0.0-x86_64-unknown-linux-gnu.tar.bz2	~/.vim/plugs/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
	sudo yum install cmake
	#这一步可能会卡住,下载clangd的时候
	./install.py --clangd-completer

	#install Plug
	git clone https://github.com/junegunn/vim-plug
	mkdir ~/.vim/autoload
	cp vim-plug/plug.vim ~/.vim/autoload/
	#molokai
	git clone https://github.com/tomasr/molokai
	mkdir ~/.vim/colors
	cp molokai/colors/molokai.vim ~/.vim/colors/
	#安装剩下的插件
	vim -c PlugInstall
}

install_vim
install_zsh
