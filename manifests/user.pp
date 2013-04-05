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
  $locked     = false,
  $sshkeys    = [],
  $managehome = true,
  $group      = $name,
  $nodes      = [],
) {
  $user = $name

  if ! ($user) {
    fail("The ${module_name} requires at least one parameter")
  }

  if ( $state == 'present' and
    ((member($nodes, $clientcert) or member($nodes, 'all'))) ) {
    $ensure = 'present'
  } else {
    $ensure = 'absent'
  }

  validate_re($ensure, '^present$|^absent')

  validate_bool($locked)
  validate_re($shell, '^/')

  if $comment != undef {
    validate_string($comment)
  }

  validate_re($home, '^/$|[^/]$')
  if $uid != undef {
    validate_re($uid, '^\d+$')
  }
  if $gid != undef {
    validate_re($gid, '^\d+$')
  }
  validate_array($groups)
  validate_re($membership, '^inclusive$|^minimum$')
  if $password != undef {
    validate_string($password)
  }
  validate_array($sshkeys)

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
    password   => '*',
    require    => Group[$name,$groups]
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
      source  => "puppet:///files/ssh_keys/${user}.pub",
      require => File["${home}/.ssh"]
    }

    file { "${home}/.ssh/authorized_keys2":
      ensure  => absent,
    }
  }
}
