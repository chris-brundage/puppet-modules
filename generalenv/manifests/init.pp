class generalenv(
  $skel_dir                 = $generalenv::params::skel_dir,
  $user_env_config_file     = $generalenv::params::user_env_config_file,
  $profile_dir              = $generalenv::params::profile_dir,
  $user_env_file            = $generalenv::params::user_env_file,
) inherits generalenv::params {
  $user_env = "${profile_dir}/${user_env_file}"  

  file { $user_env:
    ensure => file,
    owner => 0,
    group => 0,
    mode => '0644',
    content => file($user_env_config_file),
  }
  
  file { "/root/.vimrc":
    ensure => file,
    owner => 0,
    group => 0,
    mode => '0644',
    content => file("generalenv/vimrc.conf"),
  }

  file { "/etc/screenrc":
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => file("generalenv/screenrc"),
  }

  file { "/etc/skel/.bashrc":
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => file("generalenv/skel-bashrc"),
  }

  $bashrcs = hiera_hash('rm::bashrc', undef)

  if $bashrcs == undef {
    generalenv::bashrc { '/root/.bashrc': }
  } else {
    create_resources(generalenv::bashrc, $bashrcs)
  }
}
