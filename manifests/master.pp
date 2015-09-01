class ose::master (
  $nodes, ) {

  package { 'expect': }

  file { 'expect-script':
    ensure => file,
    source => 'puppet:///modules/ose/ssh-copy-expect.sh',
    path => '/root/expect-script.sh',
    mode => '0755',
  }

  exec { 'ssh-keygen':
    command => "ssh-keygen -N '' -f '/root/.ssh/id_rsa'",
    path => '/usr/bin/:/usr/sbin/',
    creates => '/root/.ssh/id_rsa',
  }

  define process_file {
    exec { "processing $name":
      command => "expect-script.sh $name",
      path => '/root/:/usr/bin/:/usr/sbin/',
      tries => 10,
      try_sleep => 60,
      require => File['expect-script'],
    }
  } 
  
  process_file { $nodes: 
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

  # Improvement: Parameters and template for this file
  exec { 'git-ansible-hosts':
    command => "wget -O /etc/ansible/hosts http://mgmxasgitp01.infra.rit-paas.com/ritsystemuser/ansible-hosts/raw/master/etc/ansible/hosts",
    path => '/usr/bin/',
    require => Package['git'],
  }

  class { ose::master-final:
    stage => 'last',
  }
}
