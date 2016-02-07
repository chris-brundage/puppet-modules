define ssh::private_key(
    $user       = undef,
    $path       = undef,
    $filename   = 'id_rsa',
    $key        = undef,
) {
  file { "${path}/.ssh":
    ensure => directory,
    owner => $user,
    group => $user,
    mode => '0700',
    before => File["${path}/.ssh/${filename}"],
  }

  file { "${path}/.ssh/${filename}":
    ensure => 'present',
    owner => $user,
    group => $user,
    mode => '0600',
    content => template('ssh/private_key.erb'),
  }
}
