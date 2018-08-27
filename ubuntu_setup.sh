sudo apt-get install ssh xclip

# generate ssh key pairs if not exist
if [[ ! -f ~/.ssh/id_rsa ]]; then
	ssh-keygen -t rsa -b 4096
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_rsa
fi
xclip -sel clip < ~/.ssh/id_rsa.pub
echo "ssh public key copied to the clipboard, please add it to online accounts"

# vim setup
if dpkg-query -l 'vim'; then
	sudo apt remove --purge vim vim-runtime gvim
fi

sudo apt install libncurses5-dev libgnome2-dev libgnomeui-dev \
libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git \
cmake curl checkinstall build-essential fonts-powerline
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
							--enable-python3interp=yes \
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

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install powerline fonts (some not included in the Debian package)
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

# install zsh
cd
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mv .zshrc .zshrc_bak
ln -s ~/dotfiles/zshrc ~/.zshrc
