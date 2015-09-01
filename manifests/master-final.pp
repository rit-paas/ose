class ose::master-final {
  
  exec { 'ansible-playbook':
    command => "ansible-playbook /root/openshift-ansible/playbooks/byo/config.yml && touch /ansible-successful",
    path => '/usr/bin/',
    creates => "/ansible-successful",
  }

}
