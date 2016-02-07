class ssh (
    $ssh_keys               = undef,
    $ssh_private_keys       = undef,
    $ssh_authorized_keys    = undef,
) {
    if $ssh_authorized_keys != undef {
        create_resources(ssh_authorized_key, $ssh_authorized_keys)
    }

    if $ssh_private_keys != undef {
        create_resources(ssh::private_key, $ssh_private_keys)
    }

    if $ssh_keys != undef {
        create_resources(ssh::public_key, $ssh_keys)
    }
}
