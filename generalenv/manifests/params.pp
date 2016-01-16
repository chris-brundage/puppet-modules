class generalenv::params {
  $skel_dir = "/etc/skel"
  $user_env_config_file = "generalenv/user_env.sh.conf"
	
  if($operatingsystem == "CentOS") { 
    $profile_dir = "/etc/profile.d"
    $user_env_file = "user.sh"
  } else {
    $profile_dir = "/etc/profile.d"
    $user_env_file = "user.sh"
  }
}
