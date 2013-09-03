#DrupalDev nginx

Modified vagrant config from puphpet. Supports Drupal 6/7/8. Built in Drush and Composer.

#Mods
1. Removed xhprof it doesn't work in this config
2. Easier handling of vhosts and dbs (see example.pp)
3. Drush

#Usage

1. Clone Me
2. `mkdir sites`
3. `cp manifests/example.pp manifests/devsites.pp`
4. `vagrant up`

#VM Info
* Default port 33.33.33.10
* Sites built as *.drupal.dev (use dnsmasq)
* Ubuntu 12.04 - Will update to 13.04 once stable
* Port 3306 mapped to host for SQL
