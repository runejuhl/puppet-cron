# cron
#
# This class wraps *cron::instalL* for ease of use
#
# @param ensure Can be set to a package version, 'latest', 'installed',
#     'present' or 'absent'.
#
# @example
#   include 'cron'
#   class { 'cron': }

class cron (
  Variant[String, Enum[latest, installed, present, absent]] $ensure = installed,
) {
  if $ensure == 'absent' {
    file { '/etc/cron.d':
      ensure  => directory,
      recurse => true,
      force   => true,
      replace => true,
      purge   => true,
    }
  } else {
    class { '::cron::install':
      ensure => $ensure,
    }
    ->
    class { 'cron::service': }
  }

}
