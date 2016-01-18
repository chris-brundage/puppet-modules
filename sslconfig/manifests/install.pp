define sslconfig::install(
    $private_key_filename,
    $cert_filename,
    $private_key,
    $cert_name,
) {
    file { $cert_filename:
        ensure => 'present',
        mode => '0644',
        owner => 'root',
        group => 'root',
        content => file("sslconfig/${cert_name}"),
    }

    file { $private_key_filename:
        ensure => 'present',
        mode => '0644',
        owner => 'root',
        group => 'root',
        content => $private_key,
    }
}
