#!/usr/bin/perl
#
# send-impl.pl, Eric Busboom, November, 1999
#
# usage: send-impl.pl cluster
#
# Given a cluster file, this code will encapsulate each component in
# the cluster, wrap it in MIME, and copy it to stdout. You can find a
# cluster file in the 'test' directory


use lib "../../blib/lib";
use lib "../../blib/arch";
use lib "../../";

use Net::ICal;
use Net::ICal::Calendar;
use Net::ICal::Cluster;
use Getopt::Std;

use MIME::Entity;
use MIME::Parser;

use Getopt::Std;


sub send_mime{

  my $c = shift;
  my $method;

  @props = $c->properties('METHOD');
  
  if ($props[0]){
    $method = $props[0]->get_value_ref->as_ical_string();
  } else {
    $method = "PUBLISH";
  }
  
  $top = build MIME::Entity Type    =>"multipart/mixed",
  From    => "eric\@busboom.org",
  To      => "alice",
  Subject => "Hello, nurse!",
  Data => "This is a calendar";

  
  $top->attach (Data=>"Hey! Come to the meeting!");
  
  $cal = MIME::Entity->build (Data        =>  $c->as_ical_string(),
			      Type        => "text/calendar",
			      Encoding    => "7bit");
  
  $top->add_part($cal);
  
  $cal->head->replace('content-type', "text/calendar; method=$method; charset=US-ASCII");

  
  $top->print(\*STDOUT);
  print "\n\n";
}

my $cluster = new Net::ICal::Cluster($ARGV[0]);

for ($c = $cluster->first();$c != undef;$c = $cluster->next()){
  send_mime($c);
}
