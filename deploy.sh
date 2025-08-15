#!/bin/bash
#
# This script pulls changes from blog repo, builds it and updates nginx site content
#

REGULAR_USER=user
SOURCE_PATH=/path/to/source
SITE_PATH=/var/www/Blog

if [[ `whoami` != 'root' ]]; then
    echo "This script is supposed to be run by root."
    exit 1
fi

mkdir -p $SITE_PATH/backup
rsync -av --progress --delete $SITE_PATH/ $SITE_PATH/backup --exclude backup

su $REGULAR_USER -c "cd $SOURCE_PATH; git fetch && git pull && hugo"

mv $SITE_PATH/backup /tmp
rsync -av --progress --delete $SOURCE_PATH/public/ $SITE_PATH
mv /tmp/backup $SITE_PATH

chown -R nginx:nginx $SITE_PATH
chmod -R 755 $SITE_PATH