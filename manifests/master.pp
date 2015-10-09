class ose::master (
  $public_cluster_name,
  $default_subdomain,
  $default_node_selector,
  $ssh_key_to,
  $root_pw,
  $masters,
  $nodes, ) {

  package { 'expect': }

  file { '/root/expect-script.sh':
    ensure => present,
    content => template('ose/ssh-copy-expect.sh.erb'),
    mode => '0755',
  }

  exec { 'ssh-keygen':
    command => "ssh-keygen -N '' -f '/root/.ssh/id_rsa'",
    path => '/usr/bin/:/usr/sbin/',
    creates => '/root/.ssh/id_rsa',
  }

  define ssh-copy {
    exec { "ssh-copy-id to $name":
      command => "expect-script.sh $name",
      path => '/root/:/usr/bin/:/usr/sbin/',
      tries => 10,
      try_sleep => 60,
      require => File['/root/expect-script.sh'],
    }
  } 
  

  ssh-copy { $ssh_key_to: 
    require => Exec['ssh-keygen'],
  }

  exec { 'ansible':
    command => "yum -y --enablerepo=PAAS_V2_EPEL_7_EPEL_7_-_x86_64 install ansible",
    path => '/usr/bin/',
  }

  exec { 'git-clone':
    command => "cd /root && git clone http://mgmxasgitp01.infra.rit-paas.com/ritsystemuser/openshift-ansible.git",
    creates => "/root/openshift-ansible/playbooks/byo/config.yml",
    path => '/usr/bin/',
    require => Package['git'],
  }

  #exec { 'git-ansible-hosts':
  #  command => "wget -O /etc/ansible/hosts http://mgmxasgitp01.infra.rit-paas.com/ritsystemuser/ansible-hosts/raw/master/etc/ansible/hosts",
  #  path => '/usr/bin/',
  #  require => [Package['git'], Exec['ansible'], ],
  #  creates => '/etc/ansible/hosts'
  #}
  file { '/etc/ansible/hosts' :
    ensure => present,
    content => template('ose/hosts.erb'),
    require => Exec['ansible'],
  }
  

  class { ose::master-final:
    stage => 'last',
  }
}
