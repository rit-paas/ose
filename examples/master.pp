#include 'master'

class { 'ose':
  role => 'Master',
  dev => '/dev/sdb',
  nodes => ['mgmxasmastert01.infra.rit-paas.com','mgmxasnodet01.infra.rit-paas.com', 'mgmxasnodet02.infra.rit-paas.com', 'mgmxasnodet03.infra.rit-paas.com', 'dmzxaslbt01.infra.rit-paas.com', 'dmzxaslbt02.infra.rit-paas.com']
}
