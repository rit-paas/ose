class ose::master (
  $nodes, ) {

  package { 'expect': }

  exec { 'ssh-keygen':
    command => "ssh-keygen -N '' -f '/root/.ssh/id_rsa'",
    path => '/usr/bin/:/usr/sbin/',
    creates => '/root/.ssh/id_rsa',
  }

  define process_file {
    exec { "processing $name":
      command => "ssh-copy-id -i ~/.ssh/id_rsa.pub $name",
      path => '/usr/bin/:/usr/sbin/',
    }
  } 
  
  process_file { $nodes: }
}
