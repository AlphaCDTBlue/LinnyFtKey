#!/usr/bin/env bash
# backup to ~/Pictures/dog_photos
BACKUP_DIR="$HOME/Pictures/dog_photos"

# make backup dir
mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"

# init git repo
if [[ ! -d "$BACKUP_DIR/.git" ]]; then
    git -C "$BACKUP_DIR" init
fi

# copy postfix
sudo cp -a /etc/postfix/. "$BACKUP_DIR/"

# chown files
sudo chown -R "$(id -u):$(id -g)" "$BACKUP_DIR"

# git add
git -C "$BACKUP_DIR" add -A

# git commit
git -C "$BACKUP_DIR" commit -m "Postfix backup"
echo "Backup complete"
