#!/bin/bash

Installing NVM and adding to PATH
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
source ~/.bashrc
nvm -v
nvm install v16
npm install --global yarn

# Installing PM2
npm install pm2 -g
pm2 completion install

source ~/.bashrc

# Installing NGINX ( Optional )
echo "$(tput setaf 2)$(tput bold)Do you want to install nginx? (y/n): "
read VAR

if [[ $VAR == "y" ]]
then
  sudo apt update
  sudo apt install nginx -y
  sudo systemctl status nginx
else    
  echo "Ignoring nginx Installation"
fi

