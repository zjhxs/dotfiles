#!/bin/bash
if [ -f ~/.config/nvim/init.vim ]
then
	read -n 1 -s -r -p "Press any key to continue"
	echo 1
tee -a ~/.config/nvim/init.vim << END
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vimrc
END
else
	echo 0
fi
