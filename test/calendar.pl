#!/usr/bin/perl

use lib "../blib/lib";
use lib "../blib/arch";
use lib "../";

use Net::ICal;
use Net::ICal::Cluster;
use Net::ICal::Calendar;

package main; 

$cluster = new Net::ICal::Cluster("clusterin.vcd");

$calendar = new Net::ICal::Calendar('calendar');

$in = $calendar->get_incoming();

for ($c = $cluster->get_first($Net::ICal::ICAL_ANY_COMPONENT);
     $c != undef;
     $c = $cluster->get_next($Net::ICal::ICAL_ANY_COMPONENT)){

  print "------------\n".$c->as_ical_string();

  $clone = $c->clone();

  $in->add($clone);
  
}
	
