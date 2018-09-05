name             'osl-nfs'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
issues_url       'https://github.com/osuosl-cookbooks/osl-nfs/issues'
source_url       'https://github.com/osuosl-cookbooks/osl-nfs'
license          'Apache-2.0'
chef_version     '>= 12.18' if respond_to?(:chef_version)
description      'Installs/Configures osl-nfs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.4'

depends          'base'
depends          'kernel-modules'
depends          'nfs', '~> 2.4.1'
depends          'line', '< 2.0.0'
depends          'firewall'

supports         'centos', '~> 6.0'
supports         'centos', '~> 7.0'
