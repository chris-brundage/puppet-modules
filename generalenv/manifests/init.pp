class generalenv(
  $skel_dir                 = $generalenv::params::skel_dir,
  $use_default_profile      = false,
  $profile_dir              = $generalenv::params::profile_dir,
  $profiles                 = undef,
) inherits generalenv::params {
  if $use_default_profile {
    $default_profile = "${profile_dir}/default_profile.sh"

    file { $default_profile:
      ensure => file,
      owner => 'root',
      group => 'root',
      mode => '0644',
      content => file('generalenv/default_profile.sh'),
    }
  }

  if $profiles != undef {
    create_resources(generalenv::profile, $profiles)
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
