#!perl -w

use Test::More no_plan;

# From line 170
use lib "./lib";
use Net::ICal::Journal;
use Net::ICal::Attendee;
%bogusargs = ();
%args = ( organizer => new Net::ICal::Attendee('mailto:alice@example.com'));
ok($c = new Net::ICal::Journal ( %args ), "Create a Journal object");
#ok(not( $d = new Net::ICal::Journal ( %bogusargs )), "Create a bogus Journal object");


# From line 203
ok($c->validate          , "Simple validation should pass");
#ok(not($d->validate), "Bogus args should fail");


