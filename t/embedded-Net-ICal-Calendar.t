#!perl -w

use Test::More no_plan;

# From line 98

use Net::ICal::Calendar;
use Net::ICal::Event;

my $c = Net::ICal::Calendar->new();

ok(!(defined($c)), "create fails properly if params are empty");

$c = Net::ICal::Calendar->new (events => [
            Net::ICal::Event->new(dtstart => '20010402T021030Z')
                                ]);

ok(defined($c), 'create passes if at least one event');



