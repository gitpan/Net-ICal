#!perl -w

use Test::More no_plan;

# From line 49

use lib './lib';
use Net::ICal;
$duration = Net::ICal::Duration->new ('PT5M');
$datetime = Net::ICal::Time->new (ical => '20000101T073000');

ok(Net::ICal::Trigger->new (300), "Create from integer number of seconds");
ok(Net::ICal::Trigger->new ($duration), "Create from a Net::ICal::Duration");
ok(Net::ICal::Trigger->new ($datetime), "Create from a Net::ICal::Time");


