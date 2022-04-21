#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

allUsers=false
while true; do
    read -p "Install for all users? [yes/no]" yn
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


## Install Oh my Posh
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
chmod +x /usr/local/bin/oh-my-posh

## Download the themes
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip