#include 'master'

class { 'ose':
  role => 'Master',
  dev => '/dev/vdb',
  public_cluster_name => 'manage.dev.pcap.at',
  default_subdomain => 'dev.pcap.at',
  default_node_selector => 'region=primary',
  masters => [
              {hostname => 'mgmxasmasterd01.infra.rit-paas.com', labels => "{'region': 'infra', 'zone': 'default'}"},
             ],
  nodes => [
            {'hostname' => 'mgmxasnoded01.infra.rit-paas.com', 'labels' => "{'region': 'primary', 'zone': 'east'}"},
            {'hostname' => 'mgmxasnoded02.infra.rit-paas.com', 'labels' => "{'region': 'primary', 'zone': 'east'}"},
            {'hostname' => 'mgmxasnoded03.infra.rit-paas.com', 'labels' => "{'region': 'primary', 'zone': 'west'}"},
            {'hostname' => 'dmzxaslbd01.infra.rit-paas.com', 'labels' => "{'region': 'dmz', 'zone': 'west'}"},
            {'hostname' => 'dmzxaslbd02.infra.rit-paas.com', 'labels' => "{'region': 'dmz', 'zone': 'east'}"},
           ],
  ssh_key_to => [ 'mgmxasmasterd01.infra.rit-paas.com', 'mgmxasnoded01.infra.rit-paas.com', 'mgmxasnoded02.infra.rit-paas.com', 'mgmxasnoded03.infra.rit-paas.com', 'dmzxaslbd01.infra.rit-paas.com', 'dmzxaslbd02.infra.rit-paas.com', ],
  root_pw => 'SECRETPASSWORDFORROOT',
}
