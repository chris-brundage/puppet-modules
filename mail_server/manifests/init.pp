class mail_server (
    $db_user,
    $db_password,
    $db_name,
    $db_host
) {
    file { '/etc/skel/mail':
        owner => 'root',
        group => 'root',
        mode => '0700',
        ensure => directory,
    }

    include amavis
    include dovecot
    include postfix::server

    package { 'spamassassin':
        ensure => 'present',
    }

    group { 'vmail':
       gid => 5000,
       ensure => 'present',
    }

    user { 'vmail':
        uid => 5000,
        ensure => 'present',
        home => '/var/vmail',
        managehome => true,
        shell => '/bin/sh',
        require => Group['vmail'],
        before => Class['dovecot'],
    }

    file { '/etc/postfix/regex':
        ensure => directory,
    }

    file { '/etc/postfix/sasl':
        ensure => directory,
    }

    file { '/etc/postfix/regex/tag_as_foreign':
        ensure => present,
        content => file('mail_server/regex_tag_as_foreign'),
        require => File['/etc/postfix/regex'],
    }  

    file { '/etc/postfix/regex/tag_as_originating':
        ensure => present,
        content => file('mail_server/regex_tag_as_originating'),
        require => File['/etc/postfix/regex'],
    }  

    file { '/etc/postfix/sasl/smtpd.conf':
        ensure => present,
        content => file('mail_server/sasl_smtpd.conf'),
        require => File['/etc/postfix/sasl'],
    }

    $sql_cf_files = hiera_hash('mail_server::sql_cf', undef)

    if $sql_cf_files != undef {
        file { '/etc/postfix/sql':
            ensure => directory,
        }
        $options = { require => File['/etc/postfix/sql'] }

        create_resources(mail_server::sql_cf, $sql_cf_files, $options)
    }

    file { '/etc/dovecot/sieve':
        ensure => directory, 
        owner => 'root',
        group => 'dovecot',
        mode => '0750',
        require => Class['Dovecot'],
    }

    file { '/etc/dovecot/sieve/globalsieverc':
        ensure => present,
        owner => 'root',
        group => 'dovecot',
        mode => '0640',
        content => file('mail_server/globalsieverc'),
        require => File['/etc/dovecot/sieve'],
    }
}
