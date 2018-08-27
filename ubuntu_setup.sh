if dpkg-query -l 'vim'; then
	sudo apt remove --purge vim vim-runtime gvim
fi

sudo apt install libncurses5-dev libgnome2-dev libgnomeui-dev \
libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git \
cmake checkinstall
cd ~
mkdir build
cd build
git clone https://github.com/vim/vim.git
git clone https://github.com/universal-ctags/ctags
cd vim
# configure vim features
./configure --with-features=huge \
							--enable-multibyte \
							--enable-rubyinterp=yes \
							--enable-pythoninterp=yes \
							--with-python3-config-dir=/usr/lib/python3.5/config \
							--enable-perlinterp=yes \
							--enable-luainterp=yes \
							--enable-gui=gtk2 \
							--enable-cscope \
							--prefix=/usr/local
make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
sudo checkinstall

# update the default editor
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim

cd ../ctags
./autogen.sh
./configure
sudo checkinstall
cd ..

sudo apt-get install fonts-powerline
