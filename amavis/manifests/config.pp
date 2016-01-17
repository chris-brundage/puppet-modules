class amavis::config (
    $max_servers                = 2,
    $daemon_user                = 'amavis',
    $daemon_group               = 'amavis',
    $mydomain                   = $::domain,
    $myhome                     = '/var/spool/amavisd',
    $lock_file                  = '/var/run/amavisd/amavisd.lock',
    $pid_file                   = '/var/run/amavisd/amavisd.pid',
    $log_level                  = 0,
    $syslog                     = true,
    $syslog_facility            = 'mail',
    $enable_dkim_verification   = 1,
    $dkim_signing               = false,
    $dkim_path                  = '/var/db/dkim',
    $dkim_keys                  = undef,
    $mynetworks                 = ['127.0.0.0/8', '[::1]'],
    $inet_socket_ports          = ['10024', '10026'],
    $postmaster                 = 'postmaster\@brundage.me',
    $clamav                     = true,
    $final_virus_destiny        = 'D_DISCARD',
    $final_banned_destiny       = 'D_BOUNCE',
    $final_spam_destiny         = 'D_BOUNCE',
    $final_bad_header_destiny   = 'D_DISCARD',
) {
    if $clamav == true {
        package { [ 'clamav', 'clamav-data', 'clamav-update', 'clamav-devel', 'clamav-server-systemd' ]:
            ensure => present,
        }

        file { '/etc/sysconfig/clamd.amavisd':
            ensure => present,
            content => file('amavis/sysconfig_clamd.amavisd'),
        }

        file { '/etc/tmpfiles.d/clamd.amavisd.conf':
            ensure => present,
            content => template('amavis/tmpfiles_clamd.amavisd.erb'),
        }

        service { 'clamd@amavisd':
            ensure => 'running',
            enable => true,
            hasstatus => true,
            hasrestart => true,
        }
    }

    file { $dkim_path:
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => '0755',
    }

    if $dkim_signing == true {
        $options = { 
            before => File['/etc/amavisd/amavisd.conf'],
            require => File[$dkim_path],
        }

        create_resources(amavis::create_dkim_key, $dkim_keys, $options)
    }

    file { '/etc/amavisd/amavisd.conf':
        ensure => present,
        content => template('amavis/amavisd.conf.erb'),
        owner => 'root',
        group => 'root',
        mode => '0644',
        notify => Service['amavisd'],
    }

}
