# Extract single site from multi site WordPress

## Require
- wp cli http://wp-cli.org/

## Usage

### move to wp multisite dir
```
$ cd wp-multi
index.php
wp-config.php
...
```

### Check the blog_id and url
```
$ wp site list
+---------+--------------------------+-------------+------------+
| blog_id | url                      | last_updated| registered |
+---------+--------------------------+-------------+------------+
| 1       | http://www.example.com/ | 2017-XX-XX  | 2017-XX-XX |
| 2       | http://sub.example.com/ | 2017        | 2017       |
```

### if your `table_prefix` isn't `wp_`, edit script
```
PREFIX="wp_"
```

### Run script

```
$ sudo sh ./wp-multisite-extract.sh {blog_id} {url}
$ sudo sh ./wp-multisite-extract.sh 2 sub.example.com
```

Files are saved to `./extract/{url}/`

- export.sql.gz: database
- uploads.tar.gz: upload files
- themes.txt: active theme list. not the theme file itself. You can delete `name` in this file.
- plugins.txt: active plugin list. You can delete `name`


Download and upload to another server, or move to another dir in same server.

### Install new WordPress
```
$ wp core download
$ wp core config ...
```

No needs wp install

```
$ wp db import export.sql

$ wp plugin install `cat plugins.txt`
```

```
# Download from Official Theme Directory. If you are use own theme, skip this.
$ wp theme install `cat themes.txt` --activate

$ tar -xf uploads.tar.gz -C ./wp-content/uploads/
```

## LICENCE
MIT
