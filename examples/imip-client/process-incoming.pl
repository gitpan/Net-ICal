#!/usr/bin/perl

# This program examines the incoming queue of a calendar, extracts all
# of the messages, and books all of the VEVENT, VJOURNAL and VTODO
# components in the calendar. All other components are discarded.  
#
#
# If you are using send-imp and read-imp to generate the calendar, you
# should start with a calendar in a directory named 'alice' Before you
# run process-incoming, there should be components in the
# 'alice/incoming.ics' file. After running it, 'incoming.ics' should
# be empty, and there will be cluster files in the 'alice/booked'
# directory
# 
# This program will also create a directory 'mimemail' that will hold
# all of the attachments in the MIME input

use lib "../../blib/lib";
use lib "../../blib/arch";

use lib "/home/studio2/local/proj/Net-ICal-0.07/blib/lib";
use lib "/home/studio2/local/proj/Net-ICal-0.07/blib/arch";

$fpi = "-//Software Studio//NONSGML Libical//EN";

$calid = "alice\@cal.softwarestudio.org";

$metamail = '/usr/bin/metamail';
$metasend = '/usr/bin/metasend ';


use Net::ICal;
use Net::ICal::Calendar;
use Net::ICal::Cluster;
use Time::Local;
use POSIX;

use Getopt::Std;

getopts('o'); # If defined, program will move incoming comps to store. 

#system("date >> /home/studio2/alice-log.txt");

my $calname  = $ARGV[0]; 
$calname  =~ s/\/$//;

my $calendar = new Net::ICal::Calendar($calname);

die "Could not open calendar \'$ARGV[1]\'"  if !$calendar;

my $incoming = $calendar->get_incoming();

my $booked = $calendar->get_booked();

for($c = $incoming->first(); $c != undef; $c = $incoming->next()){

  my $methodref = ($c->properties('METHOD'))[0];
  my $method = $methodref->get_value() if $methodref;

  # Book all of the items of METHOD "PUBLISH" or  

  if ($method eq "PUBLISH" ) { 
    print "Publish\n";

    book_component($c); # only correct when $c has only one inner component
    
  } elsif ($method eq "REQUEST" ) {
    
    print "Request\n";

    my @uids = find_overlaps($c);

    if (@uids){
      return_reject_reply($c);
    } else {
      return_accept_reply($c);
      book_component($c); # only correct when $c has only one inner component
    }

  # Remove the component from the incomming cluster 
  $incoming->remove($c);

  } else { 
    print "Other, method was $method\n";

    print $c->as_ical_string();
  }
}


sub get_first_real_component {
  my $outer = shift;
  my $inner;

  foreach $i ('VEVENT','VTODO','VJOURNAL'){
    $inner = ($outer->components($i))[0];

    if ($inner){
      return $inner;
    }
  }

  return undef;
}

sub find_overlaps {
  my $outer = shift;
  my $component = get_first_real_component($outer);

  my @uids;

  return if !$component;

  my $dtstartref = ($component->properties('DTSTART'))[0];
  my $dtstart = $dtstartref->get_value() if $dtstartref;

  if (!$dtstart){
    #print $component->as_ical_string();
  }

  die "No DTSTART!" if !$dtstart;

  my $dtendref = ($component->properties('DTEND'))[0];
  my $dtend = $dtendref->get_value() if $dtendref;

  my $durationref = ($component->properties('DURATION'))[0];
  my $duration = $durationref->get_value() if $durationref;

  # Create a DTEND or DURATION, wichever one does not exist
  if ($dtendref && !$durationref ) {

    die "DTSTART and DTEND not both local or UTC" 
    if ( $dtendref->get_value_ref->isutc() 
	 xor $dtstartref->get_value_ref->isutc());
    
    my $span = timelocal($dtendref->get_value_ref->split_time()) 
    -  timelocal($dtstartref->get_value_ref->split_time());
    
    $durationref = new Net::ICal::Property::Duration("PT".$span."S");
    $duration = $durationref->get_value() if $durationref;

  } elsif (!$dtendref && $durationref ) {
    
    my $end = timelocal($dtstarref->split_time()) + $durationref->as_seconds;

    $dtendref = Net::ICal::Value::DateTime::new_from_span(localtime($end),
							  $dtstartref->is_utc());
    $dtend = $dtendref->get_value() if $dtendref;

  } else {
    print "No (or both ) of DTEND, DURATION\n";
    return;
  }

  # Now, build a Gauge to search the calendar.  A component (s1,e1)
  # overlaps with a component in the database (s0,e0) when
  # s1<e0&e1>s0. That is, when the new component starts before the
  # old one ends and ends after the old one starts

  my $gauge = new Net::ICal::Component::Xroot
  (
   new Net::ICal::Component::Vcalendar
   (
    new Net::ICal::Component::Vevent
    (
     new Net::ICal::Property::Dtstart
     (
     $dtendref->get_value(),
      new Net::ICal::Parameter::XLicComparetype("GREATER")
     ),
     new Net::ICal::Property::Dtend
     (
      $dtstartref->get_value(),
      new Net::ICal::Parameter::XLicComparetype("LESS")
     )			 
    )
   )
#,
#   new Net::ICal::Component::Vcalendar
#   (
#   new Net::ICal::Component::Any
#   (
#    new Net::ICal::Property::Dtstart
#    (
#     $dtstartref->get_value(),
#     new Net::ICal::Parameter::XLicComparetype("GREATEREQUAL")
#    ),
#    new Net::ICal::Property::Duration
#    (
#     $durationref->get_value(),
#     new Net::ICal::Parameter::XLicComparetype("LESSEQUAL")
#    )			 
#   )
#   )
  );

  $booked->select($gauge);

  my $summaryref = ($component->properties('SUMMARY'))[0];
  my $summary = $summaryref->get_value() if $summaryref;

  for($outer = $booked->get_first(); $outer != undef; $outer = $booked->get_next()){

    my $c = get_first_real_component($outer);

    my $uidref = ($c->properties('UID'))[0];
    my $uid = $uidref->get_value() if $uidref;

    push(@uids, $uid);
  }

  return @uids;
}

sub book_component
{
  my $component = shift;
  my ($uidref) = $component->properties('UID');
  my $uid = $uidref->get_value() if $uidref;

  my $clone = $component->clone();
  $booked->add($clone);
  
}

sub make_reply{
  my $comp = shift;
  my $inner = get_first_real_component($comp);

  my ($dtstampref) = $inner->properties('DTSTAMP');
  my ($uidref) = $inner->properties('UID');
  my ($organizerref) = $inner->properties('ORGANIZER');

  my $type = "Net::ICal::Component::".ucfirst(lc($inner->type()));

  my $attendee = "mailto:$calid";
  my $reply = new Net::ICal::Component::Vcalendar
  (
   new Net::ICal::Property::Method("REPLY"),
   new Net::ICal::Property::Prodid("$fpi"),
   $type->new
   (
    $dtstampref->clone(),
    $uidref->clone(),
    $organizerref->clone(),
    new Net::ICal::Property::Attendee($attendee)
   )
  );
}


sub return_reject_reply
{
  my $comp = shift;
  my $reply = make_reply($comp);

  my $inner = get_first_real_component($reply); 
  my ($attendeeref) = $inner->properties('ATTENDEE');

  my $partstat = new Net::ICal::Parameter::Partstat("DECLINED");

  $attendeeref->add($partstat);

  send_reply($reply,$comp,"Sorry, I have a nother meeting that conflicts with your proposal");

}

sub return_accept_reply
{
  my $comp = shift;

  my $reply = make_reply($comp);

  my $inner = get_first_real_component($reply); 
  my ($attendeeref) = $inner->properties('ATTENDEE');

  my $partstat = new Net::ICal::Parameter::Partstat("ACCEPTED");

  $attendeeref->add($partstat);

  send_reply($reply,$comp,"I've accepted your invitation");
}

sub send_reply
{
  my $comp = shift;
  my $orig = shift;
  my $message = shift;

  my $inner = get_first_real_component($comp); 
  my ($organizerref) = $inner->properties('ORGANIZER');
  my $to = $organizerref->get_value();

  $to =~ s/mailto://;

  my $calfile = POSIX::tmpnam();
  my $bodyfile  = POSIX::tmpnam();


  my $oinner = get_first_real_component($orig); 
  my ($summaryref) = $oinner->properties('SUMMARY');
  my $summary = $summaryref->get_value();;

  my ($startref) = $oinner->properties('DTSTART');
  my $start = $startref->get_value();

  my ($endref) = $oinner->properties('DTEND');
  my $end = $endref->get_value();

  my $data=<<EOM;
$message

Summary: $summary
From $start to $end
EOM

  open BF,">$bodyfile" or die;
  print BF $data;
  close BF;

  open CF,">$calfile" or die;
  print CF $comp->as_ical_string;
  close CF;

  system("$metasend -b -s \"Re: $summary\" -t $to -m \"text/plain\" -D \"Text\" -f $bodyfile -n -m \"text/calendar; method=REPLY\" -D \"iCalendar reply\" -f $calfile");
#  print("$metasend -b -s \"$subject\" -t $to -m \"text/plain\" -D \"Text\" -f $bodyfile -n -m \"text/calendar; method=REPLY\" -D \"iCalendar reply\" -f $calfile\n");

 unlink $bodyfile;
 unlink $calfile;


}
