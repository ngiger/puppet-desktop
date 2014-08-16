# == Class: desktop
#
# Full description of class desktop here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { desktop:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class desktop {
  # import "hostnames/*.pp"
  # replace this by hiera-variables
  notify{"hostname $hostname and $fqdn looking for classes_for_${hostname}": }
  include apt
  Exec['apt_update'] -> Package <| |>

  $hostname_classes = hiera("classes_for_${hostname}", '')
  
  if ("classes_for_$hostname" != "") {
    file{"/etc/hostname_classes":
      content => "$hostname_classes\n",
#      require => [ Class[$hostname_classes], ] # fails when more than 1 class given, eg x2go::common
    }
    include $hostname_classes
  }

  # https://forge.puppetlabs.com/puppetlabs/stdlib
  # file_line: This resource ensures that a given line is contained within a file. You can also use "match" to replace existing lines.
  # loadyaml Load a YAML file containing an array, string, or hash, and return the data in the corresponding native data type.
  #  str2saltedsha512 This converts a string to a salted-SHA512 password hash (which is used for OS X versions >= 10.7). Given any simple string, you will get a hex version of a salted-SHA512 password hash that can be inserted into your Puppet manifests as a valid password attribute.
 
  # unix chpasswd [options] DESCRIPTION     The chpasswd command reads a list of user name and password pairs from standard input and uses this information to update a group of existing users.
  # Each line is of the format:
  # user_name:password

  $hostname_packages = hiera("packages_for_${hostname}", '')
  
  if ("packages_for_$hostname" != "") {
    file{"/etc/packages_for_$hostname":
      content => join($hostname_packages, "\n"),
    }
    ensure_packages[$hostname_packages]
  }
# ensure_resource('user', 'dan', {'ensure' => 'present' }) # for users to be listed on the login site

  include apt
  if ( "$operatingsystem" == "Debian") {
    apt::source { 'debian_wheezy':
      location          => hiera('apt::source:location', 'http://mirror.switch.ch/ftp/mirror/debian/'),
      release           => hiera('apt::source:release', 'wheezy'),
      repos             => hiera('apt::source:repos', 'main contrib non-free'),
    #  required_packages => hiera('apt::source:required_packages', 'debian-keyring debian-archive-keyring'),
    #  key               => hiera('apt::source:key', '55BE302B'),
    #  key_server        => hiera('apt::source:key_server', 'subkeys.pgp.net'),
    #  pin               => hiera('apt::source:pin', '-10'),
      include_src       => hiera('apt::source:include_src', true),
    }

    apt::source { 'debian_security':
      location          => hiera('apt::source:security:location', 'http://security.debian.org/'),
      release           => hiera('apt::source:security:release', 'wheezy/updates'),
      repos             => hiera('apt::source:security:repos', 'main contrib non-free'),
      include_src       => hiera('apt::source:security:include_src', true),
    }

    
  } else {
    file{'/etc/apt/sources.list.d/debian_wheezy.list': ensure => absent }
    file{'/etc/apt/sources.list.d/debian_security.list': ensure => absent } 
  }

  if ( "$operatingsystem" == "Ubuntu") {
    # :deb http://ppa.launchpad.net/x2go/stable/ubuntu trusty main
  #     apt::ppa { "ppa:x2go/stable": }
    apt::source { 'trusty-CH':
      location   => 'http://ch.archive.ubuntu.com/ubuntu',
      release    => 'trusty',
      repos      => 'main restricted universe multiverse',
    }

    apt::source { 'trusty-security':
      location   => 'http://security.ubuntu.com/ubuntu',
      release    => 'trusty-security',
      repos      => 'main restricted universe multiverse',
    }
    apt::ppa { "universe": }
    apt::ppa { "multiverse": }
    Apt::Source['trusty-CH',  'trusty-security'] ->  Exec['apt_update'] 
    Apt::Ppa['universe',  'multiverse'] ->  Exec['apt_update']
    
    ensure_packages[
      # 'gnome-control-center', 'gnome-session',
      'libreoffice-gtk3', 'libreoffice', 'libreoffice-l10n-de', 'libreoffice-l10n-fr',
      'firefox', 'firefox-locale-de',
      'thunderbird',   'thunderbird-locale-de',
      'kubuntu-desktop',
    ]
  } else {
    ensure_packages['kdm',
      'task-german-kde-desktop', 'plasma-desktop',
      'libreoffice-gtk3', 'libreoffice', 'libreoffice-l10n-de', 'libreoffice-l10n-fr',
      'iceweasel', 'iceweasel-l10n-de',
      'icedove',   'icedove-l10n-de',
    ]
  }
  ensure_packages['kdm','libreoffice-kde', 
    'openjdk-7-jdk',
  ]
#    ensure_packages['nemo'] # cannot be installed because auf libgail-3-0
}
