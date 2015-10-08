#include 'master'

class { 'ose':
  role => 'Test',
  dev => '/dev/vdb',
  public_cluster_name => 'manage.dev.pcap.com',
  default_subdomain => 'dev.pcap.com',
  default_node_selector => 'region=primary',
  masters => [
              {name => 'mgmxasmasterd01.infra.rit-paas.com', labels => "{'region': 'infra', 'zone': 'default'}"},
             ],
  nodes => [
            {'name' => 'mgmxasnoded01.infra.rit-paas.com', 'labels' => "{'region': 'primary', 'zone': 'east'}"},
            {'name' => 'mgmxasnoded02.infra.rit-paas.com', 'labels' => "{'region': 'primary', 'zone': 'east'}"},
            {'name' => 'mgmxasnoded03.infra.rit-paas.com', 'labels' => "{'region': 'primary', 'zone': 'west'}"},
           ]
}
