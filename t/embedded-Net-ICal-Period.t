#!perl -w

use Test::More no_plan;

# From line 107


use Net::ICal::Period;

my $p = Net::ICal::Period->new();  # should FAIL

ok(!defined($p), "new() with no args fails properly");

my $begin = "19890324T123000Z";
my $end = '19890324T163000Z';
my $durstring = 'PT4H';

$p = Net::ICal::Period->new(
    Net::ICal::Time->new(ical => $begin),
    Net::ICal::Time->new(ical => $end)
    );

ok(defined($p), "new() with 2 time objects as args succeeds");

# TODO: new() tests with all the argument types listed in the
# docs. I'm *sure* some of them don't work, because the API
# for Time and Duration has changed since that POD was written. -srl

ok($p->as_ical eq "$begin/$end", "ical output is correct");


$p = Net::ICal::Period->new($begin, $end);

ok(defined($p), "new() with 2 time strings as args succeeds");

# TODO: new() tests with all the argument types listed in the
# docs. I'm *sure* some of them don't work, because the API
# for Time and Duration has changed since that POD was written. -srl

ok($p->as_ical eq "$begin/$end", "ical output is correct for dtstart/dtend");


$p = Net::ICal::Period->new($begin, $durstring);

ok(defined($p), "new() with timestring and durstring as args succeeds");

# TODO: new() tests with all the argument types listed in the
# docs. I'm *sure* some of them don't work, because the API
# for Time and Duration has changed since that POD was written. -srl

print $p->as_ical . "\n";

ok($p->as_ical eq "$begin/$durstring", "ical output is correct for dtstart/duration strings");




# From line 202

ok($p->clone() ne "Not implemented", "clone method is implemented");

$q = $p->clone();
ok($p->as_ical eq $q->as_ical , "clone method creates an exact copy");



# From line 233

ok($p->is_valid() ne "Not implemented", "is_valid method is implemented");



# From line 256

# TODO: write tests
ok(0, 'start accessor tests exist');



# From line 288

# TODO: write tests
ok(0, 'end accessor tests exist');



# From line 351

# TODO: write tests
ok(0, 'duration accessor tests exist');



# From line 396

# TODO: write tests
ok(0, "as_ical tests exist");



# From line 429

# TODO: write tests
ok(0, "as_ical_value tests exist");



# From line 454

# TODO: write tests
ok(0, "compare tests exist");



# From line 501

# TODO: write tests
ok(0, "union tests exist");



