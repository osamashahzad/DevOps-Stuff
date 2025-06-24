#!/bin/bash

# Generates SSH key for github
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

printf "$(tput setaf 2)\nSSH key generated Successfully ...!\n\n$(tput sgr0)"
cat ~/.ssh/id_ed25519.pub