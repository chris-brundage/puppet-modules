class user_management (
    $ssh_private_keys         = undef
) {
    if $ssh_private_keys != undef {
         create_resources(user_management::ssh_private_key, $ssh_private_keys)
    }
}
