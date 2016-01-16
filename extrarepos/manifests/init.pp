class extrarepos (
    $repos              = undef,
) {
    if $repos != undef {
        create_resources(extrarepos::create_repos, $repos)
    }
}
