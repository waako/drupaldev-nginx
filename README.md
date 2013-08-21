#DrupalDev nginx

Modified vagrant config from puphpet. Supports Drupal 6/7/8 (sorry no 5). Built in Drush and Composer.

#Mods
1. Removed xhprof it doesn't work in this config
2. Easier handling of vhosts and dbs (see example.pp)
3. Drush

#Usage

1. Clone Me
2. `mkdir sites`
3. `cp manifests/example.pp manifests/devsites.pp`
4. `vagrant up`
