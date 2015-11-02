class ose::prerequisites {

  exec { 'subscription-manager':
    command => 'subscription-manager repos --disable="*" && subscription-manager repos \
      --enable="rhel-7-server-rpms" \
      --enable="rhel-7-server-extras-rpms" \
      --enable="rhel-7-server-optional-rpms" \
      --enable="rhel-7-server-ose-3.0-rpms" && \
      touch /sub.managed',
    path => '/usr/sbin/:/bin/',
    notify => Exec['yum-update'],
    creates => '/sub.managed'
  }

  package { 'bash-completion': 
    require => Exec['subscription-manager'],
  }
  package { 'wget': 
    require => Exec['subscription-manager'],
  }
  package { 'git': 
    require => Exec['subscription-manager'],
  }
  package { 'net-tools': 
    require => Exec['subscription-manager'],
  }
  package { 'bind-utils': 
    require => Exec['subscription-manager'],
  }
  package { 'iptables-services': 
    require => Exec['subscription-manager'],
  }
  package { 'bridge-utils': 
    require => Exec['subscription-manager'],
  }

  exec { 'yum-update':
    command => 'yum update -y && yum erase -y NetworkManager && touch /yum.updated',
    path => '/usr/local/bin/:/bin/',
    require => Exec['subscription-manager'],
    creates => '/yum.updated',
  }

  package { 'docker': 
    require => Exec['subscription-manager'], 
  }

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
    require => Exec['docker-storage-setup'],
  }
}
