# Class: cron::install
#
# This class ensures that the distro-appropriate cron package is installed
#
# Parameters:
#   package_ensure - Can be set to a package version, 'latest', 'installed' or 'present'.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#   This class should not be used directly under normal circumstances
#   Instead, use the *cron* class.

class cron::install (
  $ensure       = installed,
  String $package_name = undef,
) {

  package {
    'cron':
      ensure => $ensure,
      name   => $package_name;
  }
}
