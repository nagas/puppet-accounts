class accounts(
  $users_yml = undef,
  $purge = false,
  $skip_users = [],
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

  User  { provider => $user_provider }
  Group { provider => $group_provider }

  create_resources('@accounts::user', loadyaml($users_yml),
                  { 'nodes' => ['all'], 'state' => 'present' })
  Accounts::User <| |>

  resources {'user':
    purge              => $purge,
    unless_system_user => $skip_users,
  }
}
