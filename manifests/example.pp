nginx::resource::vhost { 'example.drupal.dev':
  ensure       => present,
  server_drupal  => [
    'example.drupal.dev'  ],
  listen_port  => 80,
  index_files  => [
    'index.html',
    'index.htm',
    'index.php'
  ],
  www_root     => '/var/www/example.drupal.dev',
  try_files    => ['$uri', '$uri/', '/index.php?$args'],
}

nginx::resource::location { 'example.drupal.dev-php':
  ensure              => 'present',
  vhost               => 'example.drupal.dev',
  location            => '~ \.php$',
  proxy               => undef,
  try_files           => ['$uri', '$uri/', '/index.php?$args'],
  www_root            => '/var/www/example.drupal.dev',
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

mysql::db { example:
  user     => example,
  password => example,
  host     => 'localhost',
  grant    => ['all'],
}

file { "/var/www/example.drupal.dev":
  ensure => "directory",
}
