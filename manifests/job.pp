# Type: cron::job
#
# This type creates a cron job via a file in /etc/cron.d
#
# Parameters:
#   ensure - The state to ensure this resource exists in. Can be absent, present
#     Defaults to 'present'
#   minute - The minute the cron job should fire on. Can be any valid cron minute value.
#     Defaults to '*'.
#   hour - The hour the cron job should fire on. Can be any valid cron hour value.
#     Defaults to '*'.
#   date - The date the cron job should fire on. Can be any valid cron date value.
#     Defaults to '*'.
#   month - The month the cron job should fire on. Can be any valid cron month value.
#     Defaults to '*'.
#   weekday - The day of the week the cron job should fire on. Can be any valid cron weekday value.
#     Defaults to '*'.
#   environment - An array of environment variable settings.
#     Defaults to an empty set ([]).
#   mode - The mode to set on the created job file
#     Defaults to 0644.
#   user - The user the cron job should be executed as.
#     Defaults to 'root'.
#   command - The command to execute.
#     Defaults to undef.
#   comment - Optional comment to add to the crontab file
#     Defaults to undef
#
# Actions:
#
# Requires:
#
# Sample Usage:
#   cron::job {
#     'generate puppetdoc':
#       minute      => '01',
#       environment => [ 'PATH="/usr/sbin:/usr/bin:/sbin:/bin"' ],
#       command     => 'puppet doc --modulepath /etc/puppet/modules >/var/www/puppet_docs.mkd';
#   }
define cron::job(
  String $command                   = undef,
  Variant[Integer, String] $minute  = '*',
  Variant[Integer, String] $hour    = '*',
  Variant[Integer, String] $date    = '*',
  Variant[Integer, String] $month   = '*',
  Variant[Integer, String] $weekday = '*',
  Optional[String] $comment         = undef,
  Array[String] $environment        = [],
  String $user                      = 'root',
  Pattern[/[0-7]+/] $mode           = '0644',
  Enum[present, absent] $ensure     = 'present',
) {

  $_ensure_file = $ensure ? {
    'present' => file,
    'absent' => absent,
  }

  if $ensure != 'absent' {
    if ! $command {
      fail("Ensure is ${ensure}, but no command specified!")
    }
  }

  file {"job_${title}":
    ensure  => $_ensure_file,
    owner   => 'root',
    group   => 'root',
    mode    => $mode,
    path    => "/etc/cron.d/puppet_managed_${title}",
    content => template('cron/job.erb'),
  }

  # Clean up old cron jobs
  tidy { 'clean up cron.d':
    path    => '/etc/cron.d',
    matches => ['puppet_managed_*'],
    recurse => 1,
  }
}
