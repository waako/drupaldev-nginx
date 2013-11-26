import 'devsites.pp'

group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
#File { owner => 0, group => 0, mode => 0644 }

class {'apt':
  always_apt_update => true,
}

Class['::apt::update'] -> Package <|
    title != 'python-software-properties'
and title != 'software-properties-common'
|>

apt::ppa { 'ppa:rip84/php5': }

package { [
    'build-essential',
    'vim',
    'curl',
    'git-core',
    'wget',
    'zsh',
    'htop',
    'memcached',
    'unzip',
    'graphviz'
  ]:
  ensure  => 'installed',
}

class { 'nginx': }

class { 'php':
  package             => 'php5-fpm',
  service             => 'php5-fpm',
  service_autorestart => false,
  config_file         => '/etc/php5/fpm/php.ini',
  module_prefix       => ''
}

php::module {
  [
    'php5-mysql',
    'php5-cli',
    'php5-curl',
    'php5-intl',
    'php5-mcrypt',
    'php5-gd',
    'php-apc',
    'php5-memcached'
  ]:
  service => 'php5-fpm',
}

service { 'php5-fpm':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
  require    => Package['php5-fpm'],
}

class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}

class { 'xdebug':
  service => 'nginx',
}

class { 'composer':
  require => Package['php5-fpm', 'curl'],
}

puphpet::ini { 'xdebug':
  value   => [
    'xdebug.default_enable = 1',
    'xdebug.remote_autostart = 0',
    'xdebug.remote_connect_back = 1',
    'xdebug.remote_enable = 1',
    'xdebug.remote_handler = "dbgp"',
    'xdebug.remote_port = 9000'
  ],
  ini     => '/etc/php5/conf.d/zzz_xdebug.ini',
  notify  => Service['php5-fpm'],
  require => Class['php'],
}

puphpet::ini { 'php':
  value   => [
    'date.timezone = "Europe/London"',
    'sendmail_path = "/usr/bin/env /usr/local/bin/catchmail"'
  ],
  ini     => '/etc/php5/conf.d/zzz_php.ini',
  notify  => Service['php5-fpm'],
  require => Class['php'],
}

puphpet::ini { 'custom':
  value   => [
    'display_errors = On',
    'error_reporting = -1'
  ],
  ini     => '/etc/php5/conf.d/zzz_custom.ini',
  notify  => Service['php5-fpm'],
  require => Class['php'],
}

class { 'mysql::server':
  config_hash   => { 'root_password' => 'drupaldev' }
}

php::pear::module { 'drush-6.0.0RC4':
  repository  => 'pear.drush.org',
  use_package => 'no',
}

php::pear::module { 'Console_Table':
  use_package => 'no',
}

class { 'ruby':
  gems_version  => 'latest'
}

package { [
    'susy',
    'toolkit',
    'compass-rgbapng',
    'compass-normalize',
    'compass',
    'fssm',
    'chunky_png',
    'sass',
    'listen'
  ]:
  provider => 'gem',
  ensure   => 'installed',
  require  => Package[[rubygems]]
}

class { 'mailcatcher': }

class { 'xhprof': }

nginx::resource::vhost { 'xhprof.drupal.dev':
  ensure       => present,
  server_name  => [
    'xhprof.drupal.dev'  ],
  listen_port  => 80,
  index_files  => [
    'index.html',
    'index.htm',
    'index.php'
  ],
  www_root     => '/usr/share/php/xhprof_html',
  try_files    => ['$uri', '$uri/', '/index.php?$args'],
}

nginx::resource::location { 'xhprof.drupal.dev-php':
  ensure              => 'present',
  vhost               => 'xhprof.drupal.dev',
  location            => '~ \.php$',
  proxy               => undef,
  try_files           => ['$uri', '$uri/', '/index.php?$args'],
  www_root            => '/usr/share/php/xhprof_html',
  location_cfg_append => {
    'fastcgi_split_path_info' => '^(.+\.php)(/.+)$',
    'fastcgi_param'           => 'PATH_INFO $fastcgi_path_info',
    'fastcgi_param '           => $path_translated,
    'fastcgi_param  '           => $script_filename,
    'fastcgi_pass'            => '127.0.0.1:9000',
    'fastcgi_index'           => 'index.php',
    'include'                 => 'fastcgi_params'
  },
  notify              => Class['nginx::service'],
}
