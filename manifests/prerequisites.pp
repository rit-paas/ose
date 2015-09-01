class ose::prerequisites {

  exec { 'subscrption-manager':
    command => 'subscription-manager repos --disable="*" && subscription-manager repos \
      --enable="rhel-7-server-rpms" \
      --enable="rhel-7-server-extras-rpms" \
      --enable="rhel-7-server-optional-rpms" \
      --enable="rhel-7-server-ose-3.0-rpms"',
    path => '/usr/sbin/:/bin/',
  }

  package { 'NetworkManager':
    ensure => purged,
    provider => 'yum',
  }

  package { 'bash-completion': }
  package { 'wget': }
  package { 'git': }
  package { 'net-tools': }
  package { 'bind-utils': }
  package { 'iptables-services': }
  package { 'bridge-utils': }

  exec { 'yum-update':
    command => 'yum update -y',
    path => '/usr/local/bin/:/bin/',
  }

  package { 'docker': }

  file { '/etc/sysconfig/docker' :
    ensure => present,
    source => 'puppet:///modules/ose/docker',
    require => Package['docker'],
  }

  file { '/etc/sysconfig/docker-storage-setup' :
    ensure => present,
    content => template('ose/docker-storage-setup.erb'),
    require => Package['docker'],
  }

  exec { 'docker-storage-setup':
    command => 'docker-storage-setup',
    path => '/usr/sbin/:/usr/bin/',
    require => File['/etc/sysconfig/docker-storage-setup'],
    unless => 'lvs docker-vg',
  }

  service { 'docker':
    ensure => running,
  }
}
