#!perl -w

use Test::More no_plan;

# From line 70

use Net::ICal::FreebusyItem;
use Net::ICal::Period;

my $p1 = Net::ICal::Period->new("19970101T120000","19970101T123000");
my $p2 = Net::ICal::Period->new("19970101T133000","19970101T140000");

my $item1 = Net::ICal::FreebusyItem->new();   # should fail
ok(!defined($item1), 'new FreebusyItem without args should fail');

$item1 = Net::ICal::FreebusyItem->new($p1, (fbtype => 'BUSY'));
my $item2 = Net::ICal::FreebusyItem->new($p2, (fbtype => 'BUSY'));

ok(defined($item1), "creation of basic freebusyitem works");

my $item1_ical = $item1->as_ical;

$item1a = Net::ICal::FreebusyItem->new_from_ical($item1_ical);

ok($item1->as_ical eq $item1a->as_ical, 
    "exporting ical and reading it back in creates an identical object");
    
# TODO: tests that need to work eventually: see Test::More docs
# This is commented out because it's reporting a syntax error. hrm.
#todo {
#    # TODO: we ought to be able to do things like:
#    my $item3 = Net::ICal::FreebusyItem->new([$p1, $p2], (fbtype => 'BUSY'));
#    # so that both items show up on the same line. 
#    
#    ok(defined($item3), "freebusy items can be created with arrays of periods");
#
#} 1, "this code needs to be written";



