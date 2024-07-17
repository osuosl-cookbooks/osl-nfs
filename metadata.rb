name             'osl-nfs'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
issues_url       'https://github.com/osuosl-cookbooks/osl-nfs/issues'
source_url       'https://github.com/osuosl-cookbooks/osl-nfs'
license          'Apache-2.0'
chef_version     '>= 16.0'
description      'Installs/Configures osl-nfs'
version          '2.2.0'

depends          'osl-firewall'
depends          'nfs', '~> 5.0.0'

supports         'almalinux', '~> 8.0'
