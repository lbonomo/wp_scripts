#! /bin/bash

if []; then
  wp_path='./'
else 
  wp_path='./'
fi

# Backup directory.
storage='~/varios/wordpress/plugins'
[ ! -d $storage ] && mkdir -p $storage

# Check if the command exists.
function cmd_checker {
  if ! command -v $1 &> /dev/null; then
    echo -e "$(tput bold)$1$(tput sgr0) could not be found. \nPlease install it and run this script again"
    exit
  fi
}

# We need wp, jg and tar
commands="wp jq tar"
for cmd in $commands
do
  cmd_checker $cmd
done

# List of plugins to update.
# wp plugin list --allow-root --fields=name,version --update=available
update=$(wp plugin list --allow-root --format=json --fields=name,version --update=available --path=`$wp_path`)

if [ ! $? -eq 0 ]; then 
  exit
fi

# Log
echo $update > update-$(date +%s).log

echo $update | jq --raw-output 'map([.name, .version])[] | @tsv' |  while IFS=$'\t' read name version; do
  # Backup current plugin version
  if [ ! -f $storage/$name\_$version.tar.gz ]; then
    tar czf $storage/$name\_$version.tar.gz ./wp-content/plugins/$name
  fi

  # Update plugin
  wp plugin update $name --allow-root --path=`$wp_path`
done
