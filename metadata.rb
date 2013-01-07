name             "collectd"
maintainer       "DrillingInfo, Inc"
maintainer_email "dstuart@drillinginfo.com"
license          ""
description      "Installs/Configures collectd the DI2.0 way"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.5"

supports         "ubuntu"
depends          "build-essential"
depends          "collectd"
depends          'cutlery', '~> 0.1'
