class ose (
  $role,
  $dev = '/dev/vdb',
  $public_cluster_name,
  $default_subdomain,
  $default_node_selector,
  $ssh_key_to,
  $root_pw,
  $masters,
  $nodes, ) {

  stage { 'last': }
  Stage['main'] -> Stage['last']

  include ose::prerequisites

  if $role == "Master" {
    include ose::master
  }
  elsif $role == "Node" {
    include ose::node
  }
  elsif $role == "Test" {
    class { ose::test:
      masters => $masters,
      nodes => $nodes,
    }
  }
  else {
    error('Role not defined!')
  }

}
