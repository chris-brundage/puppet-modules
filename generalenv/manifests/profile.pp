define generalenv::profile(
  $ensure           = 'present',
  $env_values       = {},
) {
  file { "/etc/profile.d/${name}.sh":
    ensure => $ensure,
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('generalenv/profile.d/profile.erb'),
  }
}
