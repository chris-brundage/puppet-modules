define mail_server::sql_cf ( 
    $filename,
    $username               = $mail_server::db_user,
    $password               = $mail_server::db_password,
    $host                   = $mail_server::db_host,
    $db                     = $mail_server::db_name,
    $query
) {
    file { "/etc/postfix/sql/${filename}":
        ensure => present,
        content => template('mail_server/sql.cf.erb'),
    }
}
