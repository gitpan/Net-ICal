#!/usr/bin/perl

use lib "../blib/lib";
use lib "../blib/arch";
use lib "../";

use Net::ICal;
use Time::Local;

#use Net::ICal::Store;

package main; 


print "Starting\n";

#test_find();

print "\n---------- Test Datetime --------------\n";
test_datetime();

print "\n---------- Test Prop ------------------\n";
test_prop();

print "\n---------- Test Restriction -----------\n";
test_restriction("../test-data/single-with-error");

print "\n---------- Test Requeststatus ---------\n";
 test_requeststatus();

sub test_requeststatus()
{

  my $r = new Net::ICal::Property::RequestStatus("2.0; Success");

  print $r->as_ical_string();

  $r = new Net::ICal::Property::RequestStatus("3.1; Horrible Failure; Info about the failure");

  print $r->as_ical_string();

  $r = new Net::ICal::Property::RequestStatus("3.2");

  print $r->as_ical_string();


}


sub test_restriction
{
  my $file = shift;

  open FH, $file or die "Can't open input file \"$file\"";
  undef $/;
  my $text = <FH>;
  $/ = "\n";
  close FH;

  print "Getting text of component \n$text\n";


  $comp = new Net::ICal::Component(\$text);



  $comp->check_restrictions();
  
  print $comp->as_ical_string();

}

sub test_datetime{

  my $v = Net::ICal::Value::DateTime::new_from_localtime(localtime());

  print $v->as_ical_string(),"\n";

}

sub test_store
{

  $s = new Net::ICal::Store('store');

  if (0) {
    $c = new Net::ICal::Component::Vcalendar($p,$d);
    $c->add(
	  new Net::ICal::Property::Dtstart("19970101T" . sprintf("%02.0f",rand(1)*23) . sprintf("%02.0f",rand(1)*59) . sprintf("%02.0f",rand(1)*59) ),
	    new Net::ICal::Property::Dtend("19970101T". sprintf("%02.0f",rand(1)*23) . sprintf("%02.0f",rand(1)*59) . sprintf("%02.0f",rand(1)*59) ),
	  new Net::ICal::Property::Dtstamp("19970101T". sprintf("%02.0f",rand(1)*23) . sprintf("%02.0f",rand(1)*59) . sprintf("%02.0f",rand(1)*59) )
	   );

    $s->store($c);
  }

  $s->set_min_dtstart('19970101T080000');
  $s->set_max_dtstart('19970101T185959');

  $s->set_min_dtend('19970101T10000000');
  $s->set_max_dtend('19970101T11000000');


  my @refs = $s->get_component_refs();

  foreach $i (@refs) {
    my $c = $s->get_component($i);
    print $c->as_ical_string() if $c;
  }

}

sub test_prop {

  $c = new Net::ICal::Component::Vcalendar();

  $c->add(
	  new Net::ICal::Property::Dtstart("19970101T123456"),
	  new Net::ICal::Property::Dtend("19970101T123456"),
	  new Net::ICal::Property::Dtstamp("19970101T123456")
	 );

  @props = $c->properties("DTSTART");

  foreach $i (@props) {
    print $i->as_ical_string();
  }

}

sub test_time {

  $p = new Net::ICal::Property::Dtstart("19970101T123456");
  $v = $p->get_value_ref;
  
  print $v->as_ical_string(),"\n";
  
  $tt = Net::ICal::icalvalue_get_datetime($v->[0]);

  print Net::ICal::icaltimetype_month_get($tt),"\n";
  
  Net::ICal::icaltimetype_month_set($tt,12);
  
  Net::ICal::icalvalue_set_datetime($v->[0],$tt);
  
  print $v->as_ical_string(),"\n";
  
  
  ($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst) = $v->time();
  
  print "$sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst\n";
  
}

sub test2  {

$d = new Net::ICal::Component::Vfreebusy(new  Net::ICal::Property::Comment('Blinky'));

$param = new Net::ICal::Parameter::Cn("Foogle");

$p = new  Net::ICal::Property::Comment('Bonko',$param);
$p->set_value("Booga");

$c = new Net::ICal::Component::Vcalendar($p,$d);

$c->add(new Net::ICal::Property::Dtstart("19970101T123456"),
       new Net::ICal::Property::Dtend("19970101T123456"));

$v = $p->get_value_ref;

#print $c->as_ical_string(),"\n";

print $v->as_ical_string(),"\n";
$v->set("Fingie");
print $v->as_ical_string(),"\n";

}


