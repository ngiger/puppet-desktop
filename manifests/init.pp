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

  $display_manager =  hiera('X::display_manager', false)
  if ($display_manager) { package{$display_manager: }
    service{$display_manager:
      ensure  => running,
      require => Package[$display_manager],
    }
  }

  $window_manager =  hiera('X::window_manager', false)
  if ($window_manager) { package{$window_manager:} }

  if ( "$operatingsystem" == "Ubuntu") {
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
    'nemo',
    'openjdk-7-jdk',
  ]
}
