#!perl -w

use Test::More no_plan;

# From line 93
#generic stuff
use lib "./lib";
use Net::ICal::Attendee;
$mail = 'mailto:alice@example.com';


#start of tests
ok(my $a = Net::ICal::Attendee->new ($mail), "Simple attendee creation");
ok(not(Net::ICal::Attendee->new ("xyzzy")), "Nonsense email address");



# From line 129
ok($a->validate, "Simple validation");


