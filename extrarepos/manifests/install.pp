class extrarepos::install {
    $repo_list = hiera_hash('rmcommon::extra_repos', undef)

    if $repo_list != undef {
        create_resources(extrarepos::create_repos, $repo_list)
    }
}
