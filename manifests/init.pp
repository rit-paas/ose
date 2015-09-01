class ose (
  $role,
  $dev = 'dev/sdb',
  $nodes, ) {

  stage { 'last': }
  Stage['main'] -> Stage['last']

  include ose::prerequisites

  if $role == "Master" {
    class { ose::master:
      nodes => $nodes,
    }
    #include ose::master
  }
  elsif $role == "Node" {
    include ose::node
  }
  else {
    error('Role not defined!')
  }

}
