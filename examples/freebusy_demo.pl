#!/usr/local/bin/perl -w
use strict;

# Demo of how to use freebusys.

use lib '../lib';
use Net::ICal::Property;
use Net::ICal::Component;
use Net::ICal::Freebusy;
use Net::ICal::FreebusyItem;
use Net::ICal::Trigger;
use Net::ICal::Time;

my $p1 = new Net::ICal::Period("19970101T120000","19970101T123000");
my $p2 = new Net::ICal::Period("19970101T133000","19970101T140000");

my $item1 = new Net::ICal::FreebusyItem($p1, (fbtype => 'BUSY'));
my $item2 = new Net::ICal::FreebusyItem($p2, (fbtype => 'BUSY'));

# TODO: we ought to be able to do things like:
my $item3 = new Net::ICal::FreebusyItem([$p1, $p2], (fbtype => 'BUSY'));
# so that both items show up on the same line. This will require C::MM voodoo;
# right now it just returns an error.

my $f = new Net::ICal::Freebusy(freebusy => [$item1, $item2], comment => 'foo');

#my $t = new Net::ICal::Trigger (new Net::ICal::Time ('20000101T073000'));

print $f->as_ical . "\n";
