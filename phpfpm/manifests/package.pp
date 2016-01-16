#
# == Class: phpfpm::package
#
# Installs the php-fpm package. Do not use this class directly.
#
class phpfpm::package {

  package { $::phpfpm::package_name:
    ensure => $::phpfpm::ensure,
  }

  if $::phpfpm::ensure == 'present' {
    file { "/var/log/php-fpm":
      ensure => directory,
      owner => hiera('phpfpm::log_directory.owner', 'php-fpm'),
      group => hiera('phpfpm::log_directory.group', 'root'),
      mode => hiera('phpfpm::log_directory.mode', '0775'),
      require => Package[$::phpfpm::package_name],
    }
  }
}

