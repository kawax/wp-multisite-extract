#!/bin/bash

# The MIT License (MIT)
# Copyright (c) 2017 kawax

# Usage
# $ wp site list
# +---------+--------------------------+-------------+------------+
# | blog_id | url                      | last_updated| registered |
# +---------+--------------------------+-------------+------------+
# | 1       | http://www.exsample.com/ | 2017-XX-XX  | 2017-XX-XX |
# | 2       | http://sub.exsample.com/ | 2017        | 2017       |
#
# $ sudo sh ./wp-multisite-extract.sh {blog_id} {url}
# $ sudo sh ./wp-multisite-extract.sh 2 sub.example.com

WPCLI="/usr/local/bin/wp"
PREFIX="wp_"

DIR="./extract/$2"

mkdir -p ${DIR}

echo "database..."

${WPCLI} db export --tables=$(${WPCLI} db tables ${PREFIX}$1_* wp_users wp_usermeta --format=csv --skip-plugins --skip-themes --allow-root) /tmp/export.sql --allow-root

if [ $1 -ne 1 ]; then
  sed -i -e "s#\`$PREFIX$1_*#\`$PREFIX#g" -e "s#/wp-content/uploads/sites/$1/#/wp-content/uploads/#g" /tmp/export.sql
fi

gzip /tmp/export.sql -c > ${DIR}/export.sql.gz

echo "plugins..."
${WPCLI} plugin list --status=active --url=$2 --fields=name  --allow-root > ${DIR}/plugins.txt

echo "themes..."
${WPCLI} theme list --status=active --url=$2 --fields=name  --allow-root > ${DIR}/themes.txt

echo "uploads..."
if [ $1 -ne 1 ]; then
  tar -czf ${DIR}/uploads.tar.gz -C ./wp-content/uploads/sites/$1/ .
else
  tar -czf ${DIR}/uploads.tar.gz -C ./wp-content/uploads/ . --exclude=sites
fi

echo "done."
