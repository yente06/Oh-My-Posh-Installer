#!/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Do not run as root!"
  exit
fi

# Ask to install for all users
allUsers=false
while true; do
    read -p "Install for all users? [yes/no] " yn
    case $yn in
        [Yy]* ) allUsers=true; break;;
        [Nn]* ) allUsers=false; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ "$allUsers" = true ] ; 
    then
        echo 'Installing for all users...'
    else
        echo 'Installing for current user only...'
fi

file="/usr/local/bin/oh-my-posh"
if [ -f "$file" ]; then
    # Take action if $DIR exists. #
    while true; do
        read -p "Oh My Posh is already installed. Reinstall? [yes/no] " yn
        case $yn in
            [Yy]* ) rm -rf "${dir}"; break;;
            [Nn]* ) exit; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi


## Install Oh my Posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

## Download the themes
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip -o ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip

## Set colors
export TERM=xterm-256color

## Enable Oh My Posh
if [[ ! -e ~/.bashrc ]]; then
    cp ./src/.bashrc ~/.bashrc
fi
if [[ ! -e ~/.zshrc ]]; then
    cp ./src/.zshrc ~/.zshrc
fi
/bin/cp -rf ~/.bashrc ~/.bashrc.bak
/bin/cp -rf ~/.zshrc ~/.zshrc.bak

echo 'eval "$(oh-my-posh init bash --config ~/.poshthemes/default.omp.json)"' >> ~/.bashrc
echo 'eval "$(oh-my-posh init zsh --config ~/.poshthemes/default.omp.json)"' >> ~/.zshrc

if [ "$allUsers" = true ] ; 
    then
        # Copying themes to skel folder
        sudo /bin/cp -rf ~/.poshthemes /etc/skel/.poshthemes
        if [[ ! -e /etc/skel/.bashrc ]]; then
            sudo cp ./src/.bashrc /etc/skel/.bashrc
        fi
        if [[ ! -e /etc/skel/.zshrc ]]; then
            sudo cp ./src/.zshrc /etc/skel/.zshrc
        fi
        sudo cp /etc/skel/.bashrc /etc/skel/.bashrc.bak
        sudo cp /etc/skel/.zshrc /etc/skel/.zshrc.bak
        echo 'eval "$(oh-my-posh init bash --config ~/.poshthemes/default.omp.json)"' | sudo tee -a /etc/skel/.bashrc > /dev/null
        echo 'eval "$(oh-my-posh init zsh --config ~/.poshthemes/default.omp.json)"' | sudo tee -a /etc/skel/.zshrc > /dev/null
fi

if [ -n "$ZSH_VERSION" ]; then
   # assume Zsh
   source ~/.zshrc
elif [ -n "$BASH_VERSION" ]; then
   # assume Bash
   exec bash
else
   # assume something else
   echo "Unsupported shell type!"
fi