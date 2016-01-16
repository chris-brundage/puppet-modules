class profile::common ( 
    $packages         = undef,
    $services         = undef,
    $ssh_keys         = undef,
) {
    package { $packages:
        ensure => 'installed',
        provider => 'yum',
    }

    if $services != undef {
        create_resources(service, $services)
    }

    if $ssh_keys != undef {
        create_resources(ssh_authorized_key, $ssh_keys)
    }
}
