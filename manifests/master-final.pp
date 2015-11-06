class ose::master-final {

  $file_exists = file('/etc/openshift/master/master-config.yaml','/dev/null')

  if($file_exists != '') {

    exec { 'rename-config':
      command => "mv -f /etc/openshift/master/master-config.yaml /etc/openshift/master/renamed-master-config.yaml",
      path => '/usr/bin/',
      creates => "/ansible-successful",
    }

    exec { 'ansible-playbook':
      command => "ansible-playbook /root/openshift-ansible-current/playbooks/byo/config.yml && touch /ansible-successful",
      path => '/usr/bin/',
      creates => "/ansible-successful",
      timeout => 0,
      require => Exec['rename-config'],
      notify => Exec['replace-config'],
    }

    exec { 'replace-config':
      command => "mv -f /etc/openshift/master/renamed-master-config.yaml /etc/openshift/master/master-config.yaml",
      path => '/usr/bin/',
      refreshonly => true,
    }

    service { 'ose-master':
      ensure    => running,
      name      => 'openshift-master',
      enable    => true,
      restart   => '/etc/init.d/openshift-master restart',
      hasstatus => true,
      require   => Exec['ansible-playbook'],
    }

  } else {

    exec { 'ansible-playbook':
      command => "ansible-playbook /root/openshift-ansible-current/playbooks/byo/config.yml && touch /ansible-successful",
      path => '/usr/bin/',
      creates => "/ansible-successful",
      timeout => 0,
    }

  }

}
