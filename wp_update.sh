#! /bin/bash

# Move to path
if [ ! $# -eq 0 ]; then
    cd $1
fi

# WordPress path
wp_dir=$(pwd)

# Backup directory.
# Lando directory mapping /home/[username]:/user
storage=/user/proyectos/wordpress/plugins_backup
[ ! -d $storage ] && mkdir -p $storage

# Check if the command exists.
function cmd_checker {
  if ! command -v $1 &> /dev/null; then
    echo -e "$(tput bold)$1$(tput sgr0) could not be found. \nPlease install it and run this script again"
    exit
  fi
}

# We need wp, json_pp and tar
commands="wp jq zip"
for cmd in $commands
do
  cmd_checker $cmd
done

# List of plugins to update.
# wp plugin list --allow-root --fields=name,version --update=available
update=$(wp plugin list --allow-root --format=json --fields=name,version --update=available)

if [ ! $? -eq 0 ]; then 
  exit
fi

# Log
echo $update > update-$(date +%s).log

echo $update | jq --raw-output 'map([.name, .version])[] | @tsv' |  while IFS=$'\t' read name version; do
  # Backup current plugin version
  zipFile=$storage/$name-$version.zip
  # Move to plugins folder
  cd wp-content/plugins
  if [ ! -f $zipFile ]; then
    echo "Backing up current version of $name"
    zip -rq9 $zipFile $name
  fi
  cd $wp_dir

  # Update plugin
  wp plugin update $name --allow-root
done
