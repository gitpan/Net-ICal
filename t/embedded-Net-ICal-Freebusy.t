#!perl -w

use Test::More no_plan;

# From line 168

use Net::ICal::Freebusy;

my $f = Net::ICal::Freebusy->new();
ok(!defined($f), "new() with no arguments fails");

# TODO: add tests and make the first test pass.
#   That probably means adding in some real validation in the code.

my $p = new Net::ICal::Period("19970101T120000","19970101T123000");

# NOTE: this test should be compared to FreebusyItem to make sure it's sane.
#  I'm not at all sure it is. --srl

$f = new Net::ICal::Freebusy(freebusy => [$p], 
                             organizer => 'alice@wonderland.com');
ok(defined($f), "new() with 1 fbitem and an organizer succeeds");

my $f_ical = $f->as_ical;

my $f2 = Net::ICal::Freebusy->new_from_ical($f_ical);

ok($f2->as_ical eq $f->as_ical, 
    'reading in our output results in an identical object');



