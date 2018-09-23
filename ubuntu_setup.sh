#!/bin/bash

#remove useless stuff
sudo apt-get remove unity-webapps-common
sudo apt-get remove thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot
sudo apt-get remove gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku  landscape-client-ui-install
sudo apt-get remove onboard deja-dup
sudo apt-get remove libreoffice-common
sudo apt-get remove firefox*

# Ensure apt is set up to work with https sources
sudo apt-get install apt-transport-https
# add ppa for chrome & sublime
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo add-apt-repository ppa:papirus/papirus
sudo apt-add-repository ppa:neovim-ppa/stable

sudo apt-get update

sudo apt-get install ssh xclip sublime-text google-chrome-stable

# create symbolic link for git
ln -s ~/dotfiles/gitignore ~/.gitignore
ln -s ~/dotfiles/gitconfig ~/.gitconfig
# generate ssh key pairs if not exist
if [[ ! -f ~/.ssh/id_rsa ]]; then
	ssh-keygen -t rsa -b 4096
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_rsa
fi
xclip -sel clip < ~/.ssh/id_rsa.pub
read -n 1 -s -r -p "ssh public key copied to the clipboard, please add it to online accounts, press to continue"

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
			--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
			--enable-perlinterp=yes \
			--enable-luainterp=yes \
			--enable-gui=auto \
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

# invoke vimrc
ln -s ~/dotfiles/vimrc ~/.vimrc

# install powerline fonts (some not included in the Debian package)
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

# install neovim
sudo apt-get install neovim python-pip python3-pip
sudo -H pip install --upgrade neovim
sudo -H pip3 install --upgrade neovim
mkdir -p ~/.config/nvim
if [ -f ~/.config/nvim/init.vim ]
then
	touch ~/.config/nvim/init.vim
	echo "Create nvim init"
tee -a ~/.config/nvim/init.vim << END
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
END
else
	read -p "nvim init already exists, please check if it correctly source vimrc"
fi

# install zsh
cd
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mv .zshrc .zshrc_bak
ln -s ~/dotfiles/zshrc ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# more beautiful gnome
sudo apt install gnome-tweak-tool arc-theme papirus-icon-theme chrome-gnome-shell
