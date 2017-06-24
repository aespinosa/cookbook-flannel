name 'flannel'
description 'A library cookbook to setup flanneld'
maintainer 'Allan Espinosa'
license 'Apache-2.0'
maintainer_email 'allan.espinosa@outlook.com'
source_url 'https://github.com/aespinosa/cookbook-flannel'
issues_url 'https://github.com/aespinosa/cookbook-flannel/issues'

chef_version '>= 12.5' if respond_to(:chef_version)

version '1.1.1'

supports 'debian', '>= 8.0'
supports 'centos', '>= 7.0'
supports 'ubuntu', '>= 16.04'
