class mail_server (
    $db_user,
    $db_password,
    $db_name,
    $db_host
) {
    include postfix::server

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
}
