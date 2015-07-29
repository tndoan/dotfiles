#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim zshrc oh-my-zsh"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# install pathogen to manage plugins in Vim
mkdir -p $dir/vim/autoload $dir/vim/bundle && \
curl -LSso $dir/vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# TODO: clone git repo of oh-my-zsh and vim plugins
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" # install oh-my-zsh
cd vim/bundle
git clone https://github.com/JuliaLang/julia-vim.git
git clone https://github.com/LaTeX-Box-Team/LaTeX-Box.git
git clone --recursive https://github.com/davidhalter/jedi-vim.git
