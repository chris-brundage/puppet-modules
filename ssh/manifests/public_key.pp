define ssh::public_key(
  $user         = undef,
  $path         = undef,
  $filename     = 'id_rsa.pub',
  $key          = undef,
) {
  file { "${path}/.ssh/${filename}":
    ensure => 'present',
    owner => $user,
    group => $user,
    mode => '0644',
    content => template('ssh/public_key.erb'),
  }
}
