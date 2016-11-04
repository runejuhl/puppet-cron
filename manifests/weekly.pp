# Type: cron::weekly
#
# This type creates a cron job via a file in /etc/cron.d
#
# Parameters:
#   ensure - The state to ensure this resource exists in. Can be absent, present
#     Defaults to 'present'
#   minute - The minute the cron job should fire on. Can be any valid cron minute value.
#     Defaults to '0'.
#   hour - The hour the cron job should fire on. Can be any valid cron hour value.
#     Defaults to '0'.
#   weekday - The day of the week the cron job should fire on. Can be any valid cron weekday value.
#     Defaults to '0'.
#   environment - An array of environment variable settings.
#     Defaults to an empty set ([]).
#   user - The user the cron job should be executed as.
#     Defaults to 'root'.
#   mode - The mode to set on the created job file
#     Defaults to '0644'.
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
#   cron::weekly {
#     'delete old temp files':
#       minute      => '1',
#       hour        => '4',
#       weekday     => '7',
#       environment => [ 'MAILTO="admin@example.com"' ],
#       command     => 'find /tmp -type f -ctime +7 -exec rm -f {} \;';
#   }

define cron::weekly (
  String $command                   = undef,
  Variant[Integer, String] $minute  = 0,
  Variant[Integer, String] $hour    = 0,
  Variant[Integer, String] $weekday = 0,
  String $comment                   = undef,
  Array[String] $environment        = [],
  String $user                      = 'root',
  Pattern[/[0-7]+/] $mode           = '0644',
  Enum[present, absent] $ensure     = 'present',
) {
  cron::job {
    $title:
      ensure      => $ensure,
      minute      => $minute,
      hour        => $hour,
      date        => '*',
      month       => '*',
      weekday     => $weekday,
      user        => $user,
      environment => $environment,
      mode        => $mode,
      command     => $command,
      comment     => $comment,
  }
}
