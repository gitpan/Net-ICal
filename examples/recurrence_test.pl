#!/usr/bin/perl
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. )
#
# $Id
#
# (C) COPYRIGHT 2001, Reefknot developers, including:
#       Eric Busboom, http://www.softwarestudio.org
#======================================================================

# recurrence_test.pl: demonstrates the use of the Recurrence 
# and Recurrence classes.

use lib '../lib';

use strict;
use warnings;
use Net::ICal::Time;
use Net::ICal::Event;
use Net::ICal::Attendee;
use Net::ICal::Calendar;
use Net::ICal::Duration;
use Net::ICal::Recurrence;
use Data::Dumper;

my $attendee  = Net::ICal::Attendee->new('shutton');
my $attendee2 = Net::ICal::Attendee->new('davem');
my $attendee3 = Net::ICal::Attendee->new('mini');
my $start     = Net::ICal::Time->new(localtime(time()), 'America/Los_Angeles');
my $dur       = Net::ICal::Duration->new("PT2H0M0S");
my $end       = $start->add($dur);

my $event = Net::ICal::Event->new(
				   dtstart   => $start,
				   dtend     => $end,
				   organizer => $attendee,
				   attendee  => [ $attendee2, $attendee3 ],
                                 ) ||
  die "Didn't get a valid ICal object";

my $recur = Net::ICal::Recurrence->new(freq => 'WEEKLY');
$recur->freq('WEEKLY');
$recur->bysecond([3, 6, 9]);
$recur->byhour([3, 6, 9]);
$recur->byday([qw(+1TU WE)]);
$recur->byyearday([ 1, -2, 3, -4, -366]);
$recur->bymonthday([ 15, -1]);
$recur->bymonth([6, 8]);
$recur->byweekno([1, 2, 3]);
$recur->bysetpos([3, 8, 200, -5]);
$recur->until($end);
$recur->wkst('TU');

$event->rrule([$recur]);
$event->exrule([$recur]);

$event->exdate($end);

my $cal = Net::ICal::Calendar->new(
				    events => [ $event ],
                                  );

print $cal->as_ical;
