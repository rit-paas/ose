class ose::test (
  $masters,
  $nodes, ) {

  file { '/hosts-test' :
    ensure => present,
    content => template('ose/hosts.erb'),
  }
}
