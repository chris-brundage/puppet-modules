define user_management::ssh_private_key (
    $user                    = 'centos',
    $key                     = undef,
    $path                    = undef
) {
    if $path == undef {
        $path = "/home/${user}/.ssh/id_rsa"
    }

    if $key == undef {
        fail("You must specify a private key.")
    }

    if $user == 'root' {
         file { '/root/.ssh':
             ensure => directory,
             owner => 'root',
             group => 'root',
             mode => '0700',
             before => File[$path],
         }
    } else {
         file { "/home/${user}/.ssh": 
             ensure => directory,
             owner => $user,
             group => $user,
             mode => '0700',
             before => File[$path],
         }
    }

    file { $path:
        ensure => present,
        owner => $user,
        group => $user,
        mode => '0600',
        content => template('user_management/id_rsa.erb'),
    }
}
