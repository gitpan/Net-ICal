#!perl -w

use Test::More no_plan;

# From line 37

use Net::ICal::Todo;



# From line 159
ok($c = Net::ICal::Todo->new , "Simple creation should return an object");


# From line 185
ok( $c->validate , "Simple todo should pass");


# From line 220
#ok($c->_create(%args), "Simple _create call");


