#!/usr/bin/perl
use strict;

use lib '/home/martijn/reefknot/Net-ICal/blib/lib';

use Net::ICal::Component;
use Net::ICal::Attendee;
use Net::ICal::Duration;
use Net::ICal::Event;
use Net::ICal::Time;
use Net::ICal::Calendar;

undef $/;
open FOO, $ARGV[0];
my $cal = Net::ICal::Component->new_from_ical (<FOO>);
close FOO;
my $events = $cal->events;

print "EVENTS:\n---\n";
foreach my $evt (@$events) {
   my $altrep = $evt->summary;
   $evt->dtstart and $altrep .= " (" . scalar $evt->dtstart->as_localtime . ")\n";
   $evt->location and $altrep .= "location: " . $evt->location->{content} . "\n";
   $evt->organizer and do {
      $altrep .= "organizer: ";
      $altrep .= ($evt->organizer->cn ?
	    $evt->organizer->cn :
	    $evt->organizer->content);
   };
   $altrep .= "\n";
   print $altrep;

   if ($evt->attendee) {
      print "Attendees\n";
      foreach my $attendee (@{$evt->attendee}) {
	 my $addr = $attendee->content;
	 $addr =~ s/mailto://;
	 print "    $addr (", $attendee->partstat, ")\n";
      }
   }
   print "---\n";
}
