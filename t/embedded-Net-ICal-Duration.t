#!perl -w

use Test::More no_plan;

# From line 59

use Net::ICal::Duration;

my $d1 = Net::ICal::Duration->new(3600);
ok(defined($d1), "Simple creation from seconds");

ok($d1->as_ical_value eq 'PT1H', "Simple creation from seconds, ical output");

$d1 = undef;
$d1 = Net::ICal::Duration->new("PT10H");

ok(defined($d1), "Simple creation from ical");
ok($d1->as_ical_value eq 'PT10H', "Simple creation from ical, ical output");

# TODO: more elaborate creation tests, and some normalization tests, and
# tests that include days in them



# From line 348

# This is a really trivial test, I know. 
$d = Net::ICal::Duration->new('PT2H');

ok($d->as_ical eq ':PT2H', 
    "as_ical is correct with hour-only durations");



# From line 371

$d = Net::ICal::Duration->new('PT2H');

ok($d->as_ical_value eq 'PT2H', 
    "as_ical_value is correct with hour-only durations");



# From line 489

$d1 = Net::ICal::Duration->new('3600');

#=========================================================================
# first, tests of adding seconds
$d1->add('3600');
ok($d1->as_ical_value eq 'PT2H', "Addition of hours (using seconds) works");

$d1->add('300');
ok($d1->as_ical_value eq 'PT2H5M', "Addition of minutes (using seconds) works");

$d1->add('30');
ok($d1->as_ical_value eq 'PT2H5M30S', "Addition of seconds works");

# I know 1 day != 24 hours, but something like this should be in here.
# perhaps add should warn() on this. --srl
$d1->add(3600*24*3);
ok($d1->as_ical_value eq 'P3DT2H5M30S', "Addition of days (using seconds) works");

#TODO: there should probably be some mixed-unit testing here

#=========================================================================
# now, test adding with iCal strings

$d1 = Net::ICal::Duration->new('3600');

$d1->add('PT1H');
ok($d1->as_ical_value eq 'PT2H', "Addition of hours (using ical period) works");

$d1->add('PT5M');
ok($d1->as_ical_value eq 'PT2H5M', "Addition of minutes (using ical period) works");

$d1->add('PT30S');
ok($d1->as_ical_value eq 'PT2H5M30S', "Addition of seconds (using ical period) works");

# I know 1 day != 24 hours, but something like this should be in here.
# perhaps add should warn() on this. --srl
$d1->add('P3D');
ok($d1->as_ical_value eq 'P3DT2H5M30S', "Addition of days (using ical period) works");

#=========================================================================
# now, test adding with Duration objects 

$d1 = Net::ICal::Duration->new('3600');

$d1->add(Net::ICal::Duration->new('PT1H'));
ok($d1->as_ical_value eq 'PT2H', "Addition of hours (using ical period) works");

$d1->add(Net::ICal::Duration->new('PT5M'));
ok($d1->as_ical_value eq 'PT2H5M', "Addition of minutes (using ical period) works");

$d1->add(Net::ICal::Duration->new('PT30S'));
ok($d1->as_ical_value eq 'PT2H5M30S', "Addition of seconds (using ical period) works");

$d1->add(Net::ICal::Duration->new('P3D'));
ok($d1->as_ical_value eq 'P3DT2H5M30S', "Addition of days (using ical period) works");





# From line 566




