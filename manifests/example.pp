# Define your sites here
$sites = [
    'mikebell',
    'd8'
]

# Magix
define mySites {
  nginx::resource::vhost { '${name}.drupal.dev':
    ensure       => present,
    server_name  => [
      '${name}.drupal.dev'  ],
    listen_port  => 80,
    index_files  => [
      'index.html',
      'index.htm',
      'index.php'
    ],
    www_root     => '/var/www/${name}.drupal.dev',
    try_files    => ['$uri', '$uri/', '/index.php?$args'],
  }

  nginx::resource::location { '${name}.drupal.dev-php':
    ensure              => 'present',
    vhost               => '${name}.drupal.dev',
    location            => '~ \.php$',
    proxy               => undef,
    try_files           => ['$uri', '$uri/', '/index.php?$args'],
    www_root            => '/var/www/${name}.drupal.dev',
    location_cfg_append => {
      'fastcgi_split_path_info' => '^(.+\.php)(/.+)$',
      'fastcgi_param'           => 'PATH_INFO $fastcgi_path_info',
      'fastcgi_param '          => $path_translated,
      'fastcgi_param  '         => $script_filename,
      'fastcgi_pass'            => '127.0.0.1:9000',
      'fastcgi_index'           => 'index.php',
      'include'                 => 'fastcgi_params'
    },
    notify              => Class['nginx::service'],
  }

  mysql::db { $name:
    user     => $name,
    password => $name,
    host     => 'localhost',
    grant    => ['all'],
  }

  file { "/var/www/${name}.drupal.dev":
    ensure => "directory",
  }
}

mySites { $sites: }
