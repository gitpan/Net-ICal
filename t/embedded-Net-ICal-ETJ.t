#!perl -w

use Test::More no_plan;

# From line 77
use Net::ICal::ETJ;
use Net::ICal::Attendee;
my $c = new Net::ICal::ETJ;


# From line 140
ok(Net::ICal::ETJ::_create($foo, $class, %args), "Simple call to _create");


# From line 439
ok( $c->occurences($period)           , "Simple call to occurrences");
ok( $c->occurences($empty)            , "Empty period");
ok( not($c->occurences($bogusperiod)) , "Bogus period");


