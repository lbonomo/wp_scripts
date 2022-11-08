# wp scripts

## wp_update
This [script](./wp_update.sh) stores a currently installed plugin before updating it.

You need to set the `storage` variable to config the backup destination.

### How to use
If you run the script into the WordPress directory, just run

```
wp_update.sh 
```

But if you run, outside the WordPress installation, you must provide a installation path

```
wp_update.sh /var/www/example.net 
```


#### With Lando

Fist you neet to run `lando ssh`. Lando mapping automaticaly your `home` (in host) with `/user` (in container) so, you can run the script with the following command.

`/user/[path-of-scipt]/wp_update.sh /app/[path-of-wordpress]`
