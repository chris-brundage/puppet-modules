define amavis::create_dkim_key(
    $domain         = $name,
    $selector       = 'default',
    $key_file       = undef,
    $key            = undef,
) {
    $key_path = hiera('amavis::config::dkim_path')

    file { "${key_path}/${key_file}":
        ensure => file,
        owner => $amavis::config::daemon_user,
        group => 'root',
        mode => '0460',
        content => $key,
        require => File[$key_path],
    }
}
