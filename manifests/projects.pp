$path_translated = 'PATH_TRANSLATED $document_root$fastcgi_path_info'
$script_filename = 'SCRIPT_FILENAME $document_root$fastcgi_script_name'

nginx::resource::vhost { 'projects.drupal.dev':
  ensure       => present,
  server_name  => [
    'projects.drupal.dev'  ],
  listen_port  => 80,
  index_files  => [
    'index.html',
    'index.htm',
    'index.php'
  ],
  www_root     => '/var/www/projects.drupal.dev/www',
  try_files    => ['$uri', '$uri/', '/index.php?$args'],
}

nginx::resource::location { 'projects.drupal.dev-php':
  ensure              => 'present',
  vhost               => 'projects.drupal.dev',
  location            => '~ \.php$',
  proxy               => undef,
  try_files           => ['$uri', '$uri/', '/index.php?$args'],
  www_root            => '/var/www/projects.drupal.dev/www',
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

mysql::db { example:
  user     => example,
  password => example,
  host     => 'localhost',
  grant    => ['all'],
}

file { "/var/www/projects.drupal.dev/www":
  ensure => "directory",
}
