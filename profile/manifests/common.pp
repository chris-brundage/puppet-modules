class profile::common ( 
    $packages           = undef,
    $services           = undef,
    $ssh_keys           = undef,
    $users              = undef,
    $ssl_certificates    = undef,
) {
    if $users != undef {
        create_resources(user, $users)
    }

    if $ssl_certificates != undef {
        create_resources(sslconfig::install, $ssl_certificates)
    }

    include extrarepos

    package { $packages:
        ensure => 'installed',
        provider => 'yum',
        require => Class['Extrarepos'],
    }

    if $services != undef {
        create_resources(service, $services)
    }

    if $ssh_keys != undef {
        create_resources(ssh_authorized_key, $ssh_keys)
    }

    include generalenv
}
