#!/usr/bin/perl

use lib "../blib/lib";
use lib "../blib/arch";
use lib "../";

use Net::ICal;

use Net::ICal::Cluster;
use Net::ICal::Store;

$c = new Net::ICal::Component::Vcalendar();

$c->add(
	new Net::ICal::Property::Dtstart("19970101T123456"),
	new Net::ICal::Property::Dtend("19970101T123456"),
	new Net::ICal::Property::Dtstamp("19970101T123456")
       );



foreach $i ($c->properties()){

  print "\n--------------\n".$i->as_ical_string()."\n";

}
