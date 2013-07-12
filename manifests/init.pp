class accounts(
  $users_yaml = undef,
  $purge = false,
  $skip_sys_users = true,
  $sshkeys_source = undef,
) {
  case $::osfamily {
    RedHat: {
      $supported = true
      $user_provider = useradd
      $group_provider = groupadd
    }
    default: {
      fail("The ${module_name} module is not supported on ${::osfamily}")
    }
  }

  if ! ($users_yaml) {
    fail("The ${module_name} module requires path to yaml containing users definitions")
  }

  validate_bool($purge)
  validate_string($sshkeys_source)

  User  { provider => $user_provider }
  Group { provider => $group_provider }

  create_resources('@accounts::user', loadyaml($users_yaml),
                  { 'nodes' => ['all'], 'state' => 'present' })
  Accounts::User <| |>

  resources {'user':
    purge              => $purge,
    unless_system_user => $skip_sys_users,
  }
}
