#!perl -w

use Test::More no_plan;

# From line 44
use lib "./lib";
use Net::ICal;

$comp = new Net::ICal::Alarm(
    action => 'DISPLAY',
    trigger => "20000101T073000",
    description => "Wake Up!"
);



# From line 65
ok(0, "need tests here");


# From line 178
ok(0, "need tests here");


# From line 260
ok($comp->has_one_of ('action', 'attendee'), "we have action, so pass");
ok(not($comp->has_one_of ('summary', 'attendee')), "we have neither summary nor attendee so fail");


# From line 280
ok($comp->has_required_property ('action'), "we have action, so pass");
ok(not($comp->has_required_property ('summary')), "we don't have summary so fail");
ok($comp->has_required_property ('action','DISPLAY'), "action contains 'DISPLAY', so pass");
ok(not($comp->has_required_property ('action','nonsense')), "action doesn't contain 'nonsense', so fail");


# From line 312
ok($comp->has_illegal_property ('action'), "we have action, so fail");
ok(not($comp->has_illegal_property ('attendee')), "we don't have attendee so pass");


# From line 334
ok($comp->has_only_one_of ('action', 'summary'), "we have action, and not summary, so pass");
ok(not($comp->has_only_one_of ('action', 'trigger')), "we have both action and trigger, so fail");
ok($comp->as_only_one_of ('foo', 'bar'), "we have neither, so pass");


# From line 372
ok(&Net::ICal::Component::_identify_component("BEGIN:VTODO") eq "TODO", "Identify TODO component");
ok(Net::ICal::Component::_identify_component("BeGiN:vToDo") eq "TODO", "Identify mixed case component");
ok(not(Net::ICal::Component::_identify_component("BEGIN:xyzzy")), "can't identify nonsense component");
ok(not(Net::ICal::Component::_identify_component("")), "can't identify component in empty string");
ok(not(Net::ICal::Component::_identify_component()), "can't identify component in undef");
ok(not(Net::ICal::Component::_identify_component(123)), "can't identify component in number");
=cut


# From line 396
ok(Net::ICal::Event::_create_component("TODO"), "Create TODO component");
ok(not(Net::ICal::Event::_create_component("xyzzy")), "Can't create nonsense component");
ok(not(Net::ICal::Event::_create_component("")), "Can't create component from empty string");
ok(not(Net::ICal::Event::_create_component()), "Can't create component from undef");


# From line 425
my $unfoldlines = [];
ok(Net::ICal::Event::_unfold($unfoldlines), "Unfold valid iCal lines");
ok(not(Net::ICal::Event::_unfold("x\ny\nz\n")), "Can't unfold invalid iCal lines");


# From line 625
ok(0, "need tests here");


# From line 649
ok(0, "need tests here");


# From line 669
ok(0, "need tests here");


