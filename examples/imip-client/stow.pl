#!/usr/bin/perl
#
# stow.pl, November, 1999, Eric Busboom 
#
# This program will take a single ical component and store it in a calendar. 
# It expects to be called from metamail. You should have a .mailcap entry like:
#
#    text/calendar; /usr/local/bin/stow.pl  %s %t %{method}
#
# Then, pass the data to metamail with:
#
#    cat mail | metamail -m <relcalid>
#
# The '-m' option specifies the mailer that is calling metamail, but
# this program uses it to pass in the address where the mail was
# sent. Stow will put the incoming component in a calendar named
# <relcalid>


use lib "/home/studio2/local/proj/Net-ICal-0.07/blib/lib";
use lib "/home/studio2/local/proj/Net-ICal-0.07/blib/arch"; 

use lib "../../blib/lib";
use lib "../../blib/arch"; 

use Net::ICal;
use Net::ICal::Calendar;
use Net::ICal::Cluster;
use Getopt::Std;
use POSIX;

$calid = "alice\@cal.softwarestudio.org";

$metamail = '/usr/bin/metamail';
$metasend = '/usr/bin/metasend ';

sub return_error{
  my $to = shift;
  my $from = shift;
  my $orig = shift;
  my $text = shift;
  my $message = shift;
  my $comp = shift;

  $text =~ s/\r\n/\n/g;
  $orig =~ s/\r\n/\n/g;

  $to = $from;
  my $subject = "iMIP message error";
  
  my $bodyfile = POSIX::tmpnam();
  my $calfile = POSIX::tmprnam();

  my $data = "In your iMIP message to $to, the following error occured:\n\n$message\n";

  if ($text ne undef){ 
    $data .= "Here is the text of the component as the parser understood it:\n\n$text\n\n";
  }

  $data .= "Here is the original text of the component:\n\n$orig\n\n";

  $comp->convert_errors;

  open BF,">$bodyfile" or die;
  print BF $data;
  close BF;

  open CF,">$calfile" or die;
  print CF $comp->as_ical_string;
  close CF;

  system("$metasend -b -s \"$subject\" -t $to -m \"text/plain\" -D \"Text\" -f $bodyfile -n -m \"text/calendar; method=REPLY\" -D \"iCalendar reply\" -f $calfile");
#  print("$metasend -b -s \"$subject\" -t $to -m \"text/plain\" -D \"Text\" -f $bodyfile -n -m \"text/calendar; method=REPLY\" -D \"iCalendar reply\" -f $calfile\n");

 unlink $bodyfile;
 unlink $calfile;

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
sub store_incoming{


  my ($file, $type, $method) = @ARGV;
  my $comp;
  my $count = 0;
  my $to = $calid;
  my $summary = $ENV{'MM_SUMMARY'};


  $summary =~ /\(from (.*) \)/;

  my $from = $1;

  open FH, $file or die "Can't open input file \"$file\"";
  undef $/;
  my $text = <FH>;
  $/ = "\n";
  close FH;

#  unlink($file);

  die "No recipient" if !$to;
  
  if (!-d $ENV{'HOME'}."/.facal"){
    mkdir($ENV{'HOME'}."/.facal",0775) or die;
  }

  if ($to){
    $caldir = $ENV{'HOME'}."/.facal/$to";
  } else {
    $caldir = $ENV{'HOME'}."/.facal/default";
  }

  if (!-d $caldir){
    mkdir ($caldir,0775) or die "Can't mkdir for '$caldir/";
  }

  my $calendar = new Net::ICal::Calendar($caldir);
  
  #Net::ICal::icalcomponent_as_ical_string($calendar);
  
  die "No calendar" if !$calendar;
  
  my $incoming = $calendar->get_incoming();
  
  die "Can't get \'incoming\' cluster for calendar \'$to\'" if !$incoming;

  
  if ($type ne "text/calendar"){
    return 0 ;
  }
  
  $comp = new Net::ICal::Component(\$text);
  
  
  if (!$comp){
    return_error($to,$from,$text,undef,
		 "Found a text/component MIME part, but could not\n extract an iCal component from it\n");
    exit;
  }
  
  $comp->check_restrictions();

  if($comp->count_errors()>0){
    
    return_error($to,$from,$text,$comp->as_ical_string,
		 "Found a text/component MIME part, but it had one or more fatal \nparsing errors. (Currently all parsing errors are fatal.)\n\n",
		 $comp);
    exit;
  }
  
  
  if ($comp->type() ne "VCALENDAR"){
    return_error($to,$from,$text,$comp->as_ical_string,
		 "The root component is not a VCALENDAR",
		 $comp);
    exit;
  }
  
  my $inner = get_first_real_component($comp);
  my @attendeerefs = $inner->properties('ATTENDEE');
  my $attendee = undef;
  foreach $i (@attendeerefs){
    my $a = $i->get_value();
    
    if (lc($a) eq lc("mailto:$calid")){
      $attendee = $a;
    }
  }
  
  if (!$attendee){
    return_error($to,$from,$text,$comp->as_ical_string,
		 "The event did not list this calendar user, $calid , as an attendee. ",
		 $comp);
    exit;
  }    

  # Add some special properties
  
  $comp->add(new Net::ICal::Property::X("X-LIC-SENDER",$from));
  
  
  # Check that the version and method properties are correct 
  
  my ($version_prop) = $comp->properties("VERSION");
  
  if (!$version_prop){
    return_error($to,$from,undef,$comp->as_ical_string,
		 "No version property",$comp);
    exit;
  }
  
  my $version = $version_prop->get_value();
  
  if ($version < 2){
    return_error($to,$from,undef,$comp->as_ical_string,
		 "This version only handles iCal version 2.0",
		 $comp);
    exit;
  }
  
  my ($method_prop) = $comp->properties("METHOD");
  
  if (!$method_prop){
    return_error($to,$from,undef,$comp->as_ical_string,
		 "No method property",
		 $comp);
    exit; 
  }
  
  
  $incoming->add($comp);
  $incoming->commit();

}




######################################################################
# Main routine
######################################################################

store_incoming();
exit(0);
