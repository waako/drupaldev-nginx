#DrupalDev nginx

<<<<<<< HEAD
[![Build Status](http://r2.ayil.co.uk:8080/buildStatus/icon?job=drupaldev-nginx)](http://r2.ayil.co.uk:8080/job/drupaldev-nginx/)

Modified vagrant config from puphpet. Supports Drupal 6/7/8. Built in Drush and Composer.

#Mods
1. Removed xhprof it doesn't work in this config
2. Easier handling of vhosts and dbs (see example.pp)
3. Drush pre-installed
4. Compass pre-installed

#Usage

1. `cd drupaldev-nginx`
2. `mkdir sites`
3. `cp manifests/example.pp manifests/devsites.pp`
4. amend manfiests/devsites.php as required
5. `vagrant up`

#VM Info
* Default port 33.33.33.10
* Sites built as *.drupal.dev (use [dnsmasq](http://blakeembrey.com/articles/local-development-with-dnsmasq/))
* Port 3306 mapped to host for SQL

#Mods
1. Removed xhprof it doesn't work in this config
2. Easier handling of vhosts and dbs (see example.pp)
3. Drush
