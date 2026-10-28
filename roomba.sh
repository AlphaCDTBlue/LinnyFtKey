#!/usr/bin/env bash
sudo cp ./clean/login.defs /etc/login.defs
sudo cp ./clean/sudoers /etc/sudoers
echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"' \
    | sudo tee /etc/environment

echo "Cleaned login.defs, sudoers, environment"

sudo chmod +x ./cleanapthooks.sh ./cleanpam.sh

sudo ./cleanapthooks.sh
sudo ./cleanpam.sh --apply
