#!/bin/bash

cd ~/build/vim
git pull
make clean
./configure --with-features=huge \
			--enable-multibyte \
			--enable-rubyinterp=yes \
			--enable-python3interp=yes \
			--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
			--enable-perlinterp=yes \
			--enable-luainterp=yes \
			--enable-gui=gtk2 \
			--enable-cscope \
			--prefix=/usr/local
# pay attention to the version !!!!!
make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
sudo checkinstall

# update the default editor
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim
