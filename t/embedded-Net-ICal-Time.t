#!perl -w

use Test::More no_plan;

# From line 93
use lib "../lib";

use Net::ICal::Time;
my $t1 = new Net::ICal::Time(ical => '20010402');

ok(defined($t1), 'simple iCal creation test (date only)');

print $t1->as_ical . "\n";

# note: there *should* be a Z on the end of the string, because we assume
# that new dates are in UTC unless otherwise specified.
ok($t1->as_ical eq ':20010402Z', 'simple iCal creation (date only) makes correct iCal');

# TODO: define more tests in this vein that are Net::ICal specific.
# Mostly, you want the tests here to be Date::ICal tests; 
# Don't just add tests here unless they test something specific to N::I.



# From line 119

$t1 = new Net::ICal::Time(epoch => '22');
my $t2 = $t1->clone();

# FIXME: This test is weak because it relies on compare() working
ok($t1->compare($t2) == 0, "Clone comparison says they're the same");



# From line 150

#XXX: commented because todo tests aren't implemented yet in Test::More
#todo { ok (1==1, 'timezone testing') } 1, "no timezone support yet";



# From line 170

$t1 = Net::ICal::Time->new( ical => '20010405T160000Z');
my $d1 = Net::ICal::Duration->new ('PT15M');
print $d1->as_ical_value() . "\n";

$t1->add($d1->as_ical_value);

print $t1->ical . "\n";
ok($t1->ical eq "20010405T161500Z", "adding minutes from an iCal string works");

#---------------------------------------------------
$t1 = Net::ICal::Time->new( ical => '20010405T160000Z');
$t1->add($d1);

print $t1->ical . "\n";
ok($t1->ical eq "20010405T161500Z", "adding minutes from a Duration object works");

# NOTE: Most tests of whether the arithmetic actually works should
# be in the Date::ICal inline tests. These tests just make sure that
# N::I::Time is wrappering D::I sanely.



# From line 219

$t1 = Net::ICal::Time->new( ical => '20010405T160000Z');
$d1 = Net::ICal::Duration->new('PT15M');

$t1->subtract($d1->as_ical_value);

ok($t1->as_ical eq "20010405T154500Z", "subtracting minutes using an iCal string works");

#---------------------------------------------------
$t1 = Net::ICal::Time->new( ical => '20010405T160000Z');
$t1->subtract($d1);

print $t1->ical . "\n";

ok($t1->ical eq "20010405T1545500Z", "subtracting minutes using a Duration object works");

# NOTE: Most tests of whether the arithmetic actually works should
# be in the Date::ICal inline tests. These tests just make sure that
# N::I::Time is wrappering D::I sanely.



# From line 271
# Placeholder test, designed to fail
ok(0, "move_to_zone isn't implemented yet");



# From line 291
#TODO


# From line 315
#TODO


# From line 332
#TODO


# From line 349
#TODO


# From line 366
#TODO


# From line 386
#TODO


