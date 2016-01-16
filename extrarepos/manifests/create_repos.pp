define extrarepos::create_repos($repo_url, $repo_pkg_name, $repo_provider, $os_name = 'CentOS', $os_version = '7') {
    if $repo_provider == 'rpm' {
      if $os_version == $operatingsystemmajrelease and downcase($os_name) == downcase($::operatingsystem) {
          package { $repo_pkg_name:
              provider => $repo_provider,
              name => $repo_pkg_name,
              source => $repo_url,
              ensure => 'installed'
          }
      }
    } else {
        package { $repo_pkg_name:
            provider => $repo_provider,
            name => $repo_pkg_name,
            ensure => 'installed'
        }
    }
}
