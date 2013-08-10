#DrupalDev nginx

Shamelessly ripped from puphpet with a few modifications

#Mods
1. Removed xhprof it doesn't work in this config
2. Easier handling of vhosts and dbs (see example.pp)

#Usage

1. Clone Me
2. `mkdir sites`
3. `cp manifests/example.pp manifests/devsites.pp`
4. `vagrant up`
