#!perl -w

use Test::More no_plan;

# From line 127

use Net::ICal::Event;

my $e = Net::ICal::Event->new();

ok(!(defined($e)), 'new() called with no params should fail');

# FIXME: grah, this should work; DWIM. 
$e = Net::ICal::Event->new(dtstart => '20011031Z');

ok(defined($e), 'new() called with only dtstart(string) should succeed');

$e = Net::ICal::Event->new(dtstart => Net::ICal::Time->new(
                                        ical => '20011031Z')
                            );

ok(defined($e), 'new() called with only dtstart(object) should succeed');


# output this object as ical, then read it back in from ical and test
# to make sure nothing changed. This is the only way I can see to 
# sanely test creation of complex objects. 

my $e_ical = $e->as_ical;
my $e2 = Net::ICal::Event->new_from_ical($e_ical);
ok(defined($e2), "reading in iCal I created succeeds at a basic level");

print "e2 dtstart is " . $e2->dtstart()->as_ical . "\n";
print "e dtstart is " . $e->dtstart()->as_ical . "\n";

ok(($e2->dtstart->as_ical eq $e->dtstart->as_ical), 'iCal output and reimport of simple event works');



