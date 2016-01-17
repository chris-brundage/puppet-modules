class amavis (
    $manage_package         = true,
) {
    if $manage_package == true {
        package { 'amavisd-new':
            ensure => present,
            provider => 'yum',
        }
    }

    service { 'amavisd':
        ensure => 'running',
        enable => true,
        hasrestart => true,
        hasstatus => true
    }

    class { 'amavis::config':
        require => Package['amavisd-new'], 
    }
}
