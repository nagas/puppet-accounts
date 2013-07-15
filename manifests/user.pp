define accounts::user(
  $state = 'present',
  $shell = '/bin/bash',
  $comment = $name,
  $home = "/home/${name}",
  $uid        = undef,
  $gid        = undef,
  $groups     = [],
  $membership = 'inclusive',
  $password   = '!!',
  $sshkeys    = [],
  $managehome = true,
  $group      = $name,
  $nodes      = [],
) {
  $user = $name
  $sshkeys_source = $accounts::sshkeys_source

  validate_re($state, ['present', 'absent'])
  validate_re($membership, ['inclusive', 'minimum'])
  validate_absolute_path($shell)
  validate_absolute_path($home)
  validate_array($nodes)
  validate_array($sshkeys)
  validate_array($groups)
  validate_bool($managehome)

  if ( $state == 'present' and
    ((member_regex($nodes, $clientcert) or member_regex($nodes, 'all'))) ) {
    $ensure = 'present'
  } else {
    $ensure = 'absent'
  }

# just in case
  validate_re($ensure, ['present', 'absent'])

  if $uid != undef {
    validate_re($uid, '^\d+$')
  } else {
    fail("uid attribute not set")
  }
  if $gid != undef {
    validate_re($gid, '^\d+$')
  } else {
    fail("gid attribute not set")
  }

  group { $group:
    ensure => $ensure,
    gid    => $gid,
  }

  user { $user:
    ensure     => $ensure,
    shell      => $shell,
    comment    => $comment,
    home       => $home,
    uid        => $uid,
    gid        => $gid,
    groups     => $groups,
    membership => $membership,
    password   => $password,
    require    => $ensure? { 'present' => [Group[$name], Group[$groups]], default => [] },
  }

  if ( $managehome == true ) {
    file { $home:
      ensure  => $ensure? { 'absent' => $ensure, default => 'directory' },
      owner   => $user,
      group   => $group,
      recurse => false,
      require => [User[$user],Group[$user]],
      force   => $ensure? { 'absent' => true, default => false },
    }

    file { "${home}/.ssh":
      ensure  => $ensure? { 'present' => 'directory', default => 'absent' },
      mode    => '0700',
      owner   => $user,
      group   => $group,
      require => File[$home]
    }

    file { "${home}/.ssh/authorized_keys":
      ensure  => $ensure? { 'present' => 'file', default => 'absent'},
      mode    => '0600',
      owner   => $user,
      group   => $group,
      source  => "${sshkeys_source}/${user}.keys", 
      require => File["${home}/.ssh"]
    }

    file { "${home}/.ssh/authorized_keys2":
      ensure  => absent,
    }
  }
}
