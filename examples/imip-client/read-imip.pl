#!/usr/bin/perl
#
# read-imip.pl, November, 1999, Eric Busboom 
#
# Pass a MIME file with one or more iCal components to this program,
# and it will create a calendar from the name of the recipient,
# extract all of the components and stick them in the 'incoming'
# directory of the calendar.
#
# If you are using this with send-imp.pl, you probably want to use formail: 
#       send-imip.pl ../../test-data/rfc2446.ics | formail -ds ./read-imip.pl  
#
# The program will have no output if it accepts the component for
# storage in the calendar. It will output a reply message if the
# component has any significant errors
# 
# Note that each component in the cluster must be a VCALENDAR,
# hopefully with a VEVENT, VTODO or VJOURNAL embedded inside
#

use lib "../../blib/lib";
use lib "../../blib/arch";
use lib "../../lib";

use lib '/usr2/ebusboom/local/lib/perl';
use lib '/home/eric/proj/local/lib/perl5/site_perl/5.005/i386-linux/';


use Net::ICal;
use Net::ICal::Calendar;
use Net::ICal::Cluster;
use Getopt::Std;

use MIME::Entity;
use MIME::Parser;

sub add_part {
  my $output = shift;
  my $entity = shift;
  my $i;

  my $pre = $entity->preamble;
  my $head = $entity->head;
  my $id = $head->mime_attr('content-id');
  my $filename = $head->mime_attr('content-disposition.filename') || $id;
  
  push(@$output,[$entity->bodyhandle->as_string(),
		 $head->mime_attr('content-type'), 
		 $filename,
		$id]);
  
  if ($head->mime_attr('content-type') eq "multipart/alternative"){
    
    for($i=0; $i <$entity->parts; $i++){
      add_part($output,$entity->parts($i));
    }
  }
  
}

sub mime_parse {
  
  my @output;
  my $i;

  mkdir("mimemail",0775);
  my $parser = new MIME::Parser output_dir  => "./mimemail",
  output_prefix  => "part",
  output_to_core => 20000;
    
  $entity = $parser->read(\*STDIN) or die "couldn't parse MIME stream";
  
  my $header = $entity->head();
  my $body  = $entity->as_string() || "No Body";
  my $filename  = " ";

  if ($body){
    push(@output,[$body,$entity->effective_type, $filename," "]);
  }
  
  my $from = $header->get("From");
  chomp($from);
  my $to = $header->get('To');
  chomp($to);

  for($i=0; $i <$entity->parts; $i++){
    add_part(\@output,$entity->parts($i));
  }

  return ($from,$to,\@output);

}

sub return_error{
  my $to = shift;
  my $from = shift;
  my $orig = shift;
  my $text = shift;
  my $message = shift;
  my $comp = shift;

  $top = build MIME::Entity From    => $to,
  To      => $from,
  Subject => "iMIP message error",
  Data => $data,
  Type    =>"multipart/mixed";
  
  my $data = "In your iMIP message to $to, the following error occured:\n\n$message\n";

  if ($text ne undef){ 
    $data .= "Here is the text of the component as the parser understood it:\n\n$text\n\n";
  }

  $data .= "Here is the original text of the component:\n\n$orig\n\n";


  $top->attach (Data=>$data);


  $comp->convert_errors;
  $cal = MIME::Entity->build (Data        =>  $comp->as_ical_string(),
			      Type        => "text/calendar",
			      Encoding    => "7bit");
  
  $top->add_part($cal);
  
  $cal->head->replace('content-type', "text/calendar; method=$method; charset=US-ASCII");
  
  $top->print(\*STDOUT);
  print "\n\n";

  exit;
}

sub store_incoming{

  my ($from,$to,$parts) = mime_parse();


  die "No recipient" if !$to;
  
  mkdir ($to,0775);
  my $calendar = new Net::ICal::Calendar($to);
  
  #Net::ICal::icalcomponent_as_ical_string($calendar);
  
  die "No calendar" if !$calendar;
  
  my $incoming = $calendar->get_incoming();
  
  die "Can't get \'incoming\' cluster for calendar \'$to\'" if !$incoming;
  
  
  foreach $p (@$parts){
    
    my ($text,$type,$filename,$id) = @$p;
    my $comp;
    my $count = 0;
    
    if ($type eq "text/calendar"){
      $comp = new Net::ICal::Component(\$text);
      
      
      if (!$comp){
	return_error($to,$from,$text,undef,
		     "Found a text/component MIME part, but could not\n extract an iCal component from it\n");
	next;
      }


      if($comp->count_errors()>0){
	
	return_error($to,$from,$text,$comp->as_ical_string,
		     "Found a text/component MIME part, but it had one or more fatal \nparsing errors. (Currently all parsing errors are fatal.)\n\n",
		     $comp);
	next;
	
      }
      
      
      if ($comp->type() ne "VCALENDAR"){
	return_error($to,$from,$text,$comp->as_ical_string,
		     "The root component is not a VCALENDAR",
		     $comp);
	next;
      }
      
      
      # Add some special properties
      
      $comp->add(new Net::ICal::Property::X("X-LIC-SENDER",$from));
      
      
      # Check that the version and method properties are correct 
      
      my ($version_prop) = $comp->properties("VERSION");
      
      if (!$version_prop){
	return_error($to,$from,undef,$comp->as_ical_string,
		     "No version property",$comp);
	next;
      }
      
      my $version = $version_prop->get_value();
      
      if ($version < 2){
	return_error($to,$from,undef,$comp->as_ical_string,
		     "This version only handles iCal version 2.0",
		     $comp);
	next;
      }
      
      my ($method_prop) = $comp->properties("METHOD");
      
      if (!$method_prop){
	return_error($to,$from,undef,$comp->as_ical_string,
		     "No method property",
		     $comp);
	next; 
      }
      
      my $method = $method_prop->get_value();
      
      $incoming->add($comp);
      $incoming->commit();
    } else {
    }
  }
  
}


######################################################################
# Main routine
######################################################################

store_incoming();

