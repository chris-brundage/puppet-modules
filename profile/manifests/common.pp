class profile::common ( 
    $packages           = undef,
    $services           = undef,
    $crons              = undef,
    $users              = undef,
    $ssl_certificates   = undef,
) {
    if $users != undef {
        create_resources(user, $users)
    }

    if $ssl_certificates != undef {
        create_resources(sslconfig::install, $ssl_certificates)
    }

    if $crons != undef {
        create_resources(cron, $crons)
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

    include generalenv
}
