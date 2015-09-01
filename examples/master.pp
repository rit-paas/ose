#include 'master'

class { 'ose':
  role => 'Master',
  dev => '/dev/sdb',
  nodes => ['node01', 'node02']
}
