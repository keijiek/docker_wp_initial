#!/bin/sh

VOLUMES_DIR="volumes"
TARGET_LIST="themes plugins uploads"
USER="keijiek"

if [ -d $VOLUMES_DIR ];then
  echo "Directory exists."
  for e in $TARGET_LIST;do
    TARGET_DIR="${VOLUMES_DIR}/${e}/"
    echo $TARGET_DIR
    echo www-data:$USER
    sudo chown -R www-data:$USER $TARGET_DIR
    sudo find $TARGET_DIR -type d -exec chmod 775 {} \;
    sudo find $TARGET_DIR -type f -exec chmod 664 {} \;
  done
fi
