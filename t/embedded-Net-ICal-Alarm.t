#!perl -w

use Test::More no_plan;

# From line 69
use Net::ICal::Alarm;

my $a = Net::ICal::Alarm->new();

ok(!(defined($a)), 'new Alarm with no events should fail');


$a = Net::ICal::Alarm->new( action => 'DISPLAY', 
                            trigger => '-5M',
                            description => 'time for meeting');

ok(defined($a), 'new Alarm with DISPLAY, trigger, and desc is created');

$a = Net::ICal::Alarm->new( action => 'EMAIL', 
                            trigger => '-5M',
                            description => 'time for meeting');

ok(defined($a), 'new Alarm with EMAIL, trigger, and desc is created');

# TODO: we need as_ical tests and such. These tests are only
# barely adequate.



