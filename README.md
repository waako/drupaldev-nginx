#DrupalDev nginx

[![Build Status](http://r2.ayil.co.uk:8080/buildStatus/icon?job=drupaldev-nginx)](http://r2.ayil.co.uk:8080/job/drupaldev-nginx/)

Modified vagrant config from puphpet. Supports Drupal 6/7/8. Built in Drush and Composer.

#Tools
1. Removed xhprof it doesn't work in this config
2. Easier handling of vhosts and dbs (see example.pp)
3. Drush
4. Compass
5. Omega 4 Gems included as standard
6. APC / Memcache

#Usage

1. Clone Me
2. `mkdir sites`
3. `cp manifests/example.pp manifests/devsites.pp`
4. `vagrant up`

#VM Info
* Default port 33.33.33.10
* Sites built as *.drupal.dev (use dnsmasq)
* Ubuntu 12.04
