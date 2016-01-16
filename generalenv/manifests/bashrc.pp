define generalenv::bashrc(
  $user             = 'root',
  $home             = '/root',
  $env_vars         = undef,
  $shopts           = undef,
  $aliases          = undef,
) {
  file { "${home}/.bashrc":
    ensure => present,
    owner => $user,
    group => $user,
    mode => '0644',
    content => template('generalenv/bashrc.conf.erb'),
  }
}
