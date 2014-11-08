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

# TODO: Set console keymap  /etc/default/keyboard
# TODO: provide a way to hide users in the login, e.g. set hidden-users=nobody nobody4 noaccess in  /etc/lightdm/users.conf
# TODO: Use preseed for booting a CD
#   https://help.ubuntu.com/14.04/installation-guide/i386/preseed-contents.html
#   https://help.ubuntu.com/14.04/installation-guide/amd64/apbs02.html
class desktop(
  $ensure           = false,
  $display_manager  = 'kdm',
  $window_manager   = 'awesome',
  $language         = 'de_CH',
  $lang             = 'de_CH.UTF8',
  $lc_messages      = 'POSIX', # display system messages in english
  $desktop_packages = [
  'libreoffice', 'libreoffice-l10n-de', 'libreoffice-kde',
  'mythes-de-ch', # swiss german dictionary
  'gnucash',
   # 'lyx',
   # 'iceweasel', 'iceweasel-l10n-de',
   # 'icedove',   'icedove-l10n-de',     # for debian
  'thunderbird', 'thunderbird-locale-de',  # for ubuntu
  'firefox-locale-de', 'firefox',
  'chromium-browser', 'webaccounts-chromium-extension', 'nemo', 'openjdk-7-jdk',
  'manpages-de',
  ]
      ) {
  if ($ensure) {
    if ($display_manager) {
      ensure_packages( $desktop_packages)
      ensure_packages( [$display_manager ] )
      unless ($display_manager == 'unity') {
        service{$display_manager:
          ensure  => running,
          require => Package[$display_manager],
        }
      }
    }

    ensure_packages($window_manager)

    if ( "$operatingsystem" == "Ubuntu") {
      ensure_packages[
        # 'gnome-control-center', 'gnome-session',
        'libreoffice-gtk3', 'libreoffice', 'libreoffice-l10n-de', 'libreoffice-l10n-fr',
        'firefox', 'firefox-locale-de',
        'thunderbird',   'thunderbird-locale-de',
        'unity',
      ]
    } else {
      ensure_packages['kdm',
        'task-german-kde-desktop', 'plasma-desktop',
        'libreoffice-gtk3', 'libreoffice', 'libreoffice-l10n-de', 'libreoffice-l10n-fr',
        'iceweasel', 'iceweasel-l10n-de',
        'icedove',   'icedove-l10n-de',
        'kubuntu-desktop',
      ]
    }
    ensure_packages['kdm','libreoffice-kde',
      'nemo',
      'openjdk-7-jdk',
    ]
    file{'/etc/default/locale':
      content => "# managed by puppet/desktop/manifests/init.pp
LANG='$lang'
LANGUAGE=$language
LC_MESSAGES=$lc_messages
",
    }
    exec{"update_locale_$lang":
      command => "/usr/sbin/locale-gen $lang",
      subscribe => File['/etc/default/locale'],
      unless => "/usr/bin/locale -a | /bin/grep -i $lang",
    }
  }
}
