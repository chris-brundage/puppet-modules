define generalenv::profile(
  $ensure           = 'present',
  $env_values       = {},
  $profile_dir      = '/etc/profile.d',
) {
  file { "${profile_dir}/${name}.sh":
    ensure => $ensure,
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('generalenv/profile.d/profile.erb'),
  }
}
