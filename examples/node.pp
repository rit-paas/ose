#include 'master'

class { 'ose':
  role => 'Node',
  dev => '/dev/sdb',
  nodes => ['node01', 'node02']
}
