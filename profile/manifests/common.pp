class profile::common ( 
    $packages                       = undef,
    $packages_hash                  = undef,
    $services                       = undef,
    $crons                          = undef,
    $users                          = undef,
    $ssl_certificates               = undef,
    $letsencrypt_certificates       = undef,
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

    if $packages_hash != undef {
        $packages_options = { require => Class['Extrarepos'], }

        create_resources(package, $packages_hash, $packages_options)
    }

    if $services != undef {
        create_resources(service, $services)
    }

    include generalenv

    if $letsencrypt_certificates != undef {
        include letsencrypt

        $letsencrypt_options = {
            require => Class['Extrarepos']
        }

        create_resources(letsencrypt::certonly, $letsencrypt_certificates, $letsencrypt_options)
    }
}
