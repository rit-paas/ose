class ose (
  $role,
  $dev = 'dev/sdb',
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
    class { ose::master:
      public_cluster_name => $public_cluster_name,
      default_subdomain => $default_subdomain,
      default_node_selector => $default_node_selector,
      ssh_key_to => $ssh_key_to,
      masters => $masters,
      nodes => $nodes,
      root_pw => $root_pw,
    }
    #include ose::master
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
