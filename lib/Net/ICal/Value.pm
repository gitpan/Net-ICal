#!/usr/bin/perl
# -*- Mode: perl -*-
#======================================================================
# FILE: Value.pm
# CREATOR: eric 16 August 1999
#
# DESCRIPTION:
#   
#
#  $Id: Value.pm,v 1.6 2000/05/24 04:41:32 eric Exp $
#  $Locker:  $
#
# (C) COPYRIGHT 2000, Eric Busboom, http://www.softwarestudio.org
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. ) 
#
# The Original Code is Value.pm. The Initial Developer of the Original
# Code is Eric Busboom
#
#======================================================================

package Net::ICal::Value;
use Net::ICal;

sub new_from_ref{
   my $self = [];
   my $value_ref = shift;

   $self->[0] = $value_ref;

   return undef if !$value_ref;

   my $value_type = Net::ICal::icalvalue_isa($value_ref);

   my $type_name = Net::ICal::icalenum_value_kind_to_string($value_type);

   my $ucf = join("",map {ucfirst(lc($_));}  split(/-/,$type_name));

   my $package = "Net::ICal::Value::".$ucf;


   return bless $self, $package;
}

sub _impl{

  return $_[0]->[0];
}

sub new_clone{
   my $self = [];
   my $package = shift;
   my $orig = shift;

   my $p = Net::ICal::icalvalue_new_clone($orig->[0]);
   
   $self->[0] = $p;

   return bless $self, $package;
}


sub as_ical_string{

  my $self= shift;
  
  my $str = Net::ICal::icalvalue_as_ical_string($self->[0]);

}

sub isa{
}

package Net::ICal::Value::Duration; 
use Net::ICal;
use Time::Local;
@ISA=qw(Net::ICal::Value);

sub as_seconds {
  my $self = shift;
  my $impl = $self->_impl();
  my $dur =  Net::ICal::icalvalue_get_duration($impl);

  my($days,$weeks,$hours,$minutes,$seconds) = 
  (Net::ICal::icaldurationtype_days_get($dur),
   Net::ICal::icaldurationtype_weeks_get($dur),
   Net::ICal::icaldurationtype_hours_get($dur),
   Net::ICal::icaldurationtype_minutes_get($dur),
   Net::ICal::icaldurationtype_seconds_get($dur),
 );

  my $s = $seconds + 
  $minutes*60 + 
  $hours * 60 * 60 + 
  $days * 60 * 60 * 24 + 
  $weeks * 60 * 60 * 24 * 7;

  return $s;
  

}

package Net::ICal::Value::DateTime;
use Net::ICal;
use Time::Local;
@ISA=qw(Net::ICal::Value);

sub isutc {
  my $self = shift;
  my $impl = $self->_impl();
  my $tt = Net::ICal::icalvalue_get_datetime($impl);

  return Net::ICal::icaltimetype_is_utc_get($tt);
  
}

sub split_time
{

  my $self = shift;
  my $impl = $self->_impl();
  my $tt = Net::ICal::icalvalue_get_datetime($impl);

  my ($year,$month,$day,$hour,$minute,$second,$isutc,$isdate) = 
  (Net::ICal::icaltimetype_year_get($tt),
  Net::ICal::icaltimetype_month_get($tt),
  Net::ICal::icaltimetype_day_get($tt),
  Net::ICal::icaltimetype_hour_get($tt),
  Net::ICal::icaltimetype_minute_get($tt),
  Net::ICal::icaltimetype_second_get($tt),
  Net::ICal::icaltimetype_is_utc_get($tt),
  Net::ICal::icaltimetype_is_date_get($tt));

  my ($usec,$umin,$uhour,$umday,$umon,$uyear,$uwday,$uyday,$uisdst);

  if($isutc) {

    ($usec,$umin,$uhour,$umday,$umon,$uyear,$uwday,$uyday,$uisdst) 
    = gmtime(timegm($second,$minute,$hour,$day,$month-1,$year-1900,
		    undef,undef,undef));
  } else {

    ($usec,$umin,$uhour,$umday,$umon,$uyear,$uwday,$uyday,$uisdst) 
    = localtime(timelocal($second,$minute,$hour,$day,$month-1,$year-1900,
		    undef,undef,undef));
  }

  return ($usec,$umin,$uhour,$umday,$umon+1,$uyear,$uwday,$uyday,$uisdst);

}

sub new_from_localtime
{
  
  my $time = shift;

  return new_from_split(localtime($time),0);
} 

sub new_from_split
{
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst,$isutc) = @_;

  my $fmt;

  if($isutc){
    $fmt = "%04s%02s%02sT%02s%02s%02sZ";
  } else {
    $fmt = "%04s%02s%02sT%02s%02s%02s";
  }

  return new Net::ICal::Value::DateTime(sprintf($fmt,$year+1900,$mon+1,$mday,$hour,$min,$sec));

}

package Net::ICal::Value::Date;
use Net::ICal;
use Time::Local;
@ISA=qw(Net::ICal::Value);

sub isutc {
  return 0;
}

sub split_time
{

  my $self = shift;
  my $impl = $self->_impl();
  my $tt = Net::ICal::icalvalue_get_datetime($impl);

  my ($year,$month,$day,$hour,$minute,$second,$isutc,$isdate) = 
  (Net::ICal::icaltimetype_year_get($tt),
  Net::ICal::icaltimetype_month_get($tt),
  Net::ICal::icaltimetype_day_get($tt),
   0,
   0,
   0,
   0,
  Net::ICal::icaltimetype_is_date_get($tt));

  my($usec,$umin,$uhour,$umday,$umon,$uyear,$uwday,$uyday,$uisdst) 
  = localtime(timelocal($second,$minute,$hour,$day,$month-1,$year-1900,
			undef,undef,undef));



  return (0,0,0,$umday,$umon+1,$uyear,$uwday,$uyday,0);

}

sub new_from_localtime
{
  
  my $time = shift;

  return new_from_split(localtime($time),0);
} 

sub new_from_split
{
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst,$isutc) = @_;

  my $fmt;

  if($isutc){
    $fmt = "%04s%02s%02s";
  } else {
    $fmt = "%04s%02s%02s";
  }

  return new Net::ICal::Value::Date(sprintf($fmt,$year+1900,$mon+1,$mday));

}

# Everything below this line is machine generated. Do not edit. 

package Net::ICal::Value::Attach; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_ATTACH_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_ATTACH_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_ATTACH_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Binary; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_BINARY_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_BINARY_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_BINARY_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Boolean; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_BOOLEAN_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_BOOLEAN_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_BOOLEAN_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::CalAddress; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_CALADDRESS_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_CALADDRESS_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_CALADDRESS_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Date; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATE_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_DATE_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATE_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::DateTime; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIME_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_DATETIME_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIME_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::DateTimeDate; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEDATE_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_DATETIMEDATE_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEDATE_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::DateTimePeriod; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEPERIOD_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_DATETIMEPERIOD_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEPERIOD_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Duration; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DURATION_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_DURATION_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DURATION_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Float; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_FLOAT_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_FLOAT_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_FLOAT_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Geo; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_GEO_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_GEO_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_GEO_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Integer; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_INTEGER_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_INTEGER_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_INTEGER_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Method; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_METHOD_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_METHOD_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_METHOD_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Period; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_PERIOD_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_PERIOD_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_PERIOD_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Recur; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_RECUR_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_RECUR_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_RECUR_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::String; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_STRING_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_STRING_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_STRING_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Text; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_TEXT_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Time; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TIME_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_TIME_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TIME_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Trigger; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TRIGGER_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_TRIGGER_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TRIGGER_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Uri; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_URI_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_URI_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_URI_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::UtcOffset; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_UTCOFFSET_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_UTCOFFSET_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_UTCOFFSET_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}


package Net::ICal::Value::Query; 
use Net::ICal::Value;
@ISA=qw(Net::ICal::Value);
sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value){
      $p = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_QUERY_VALUE,$value);
   } else {
      $p = Net::ICal::icalvalue_new($Net::ICal::ICAL_QUERY_VALUE);
   }

   $self->[0] = $p;

   return $self;
}

sub set
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();

   if ($v) {
      my $new_value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_QUERY_VALUE,$v);
      if ($new_value){
         Net::ICal::icalvalue_free($self->[0]);
          $self->[0] = $new_value;
      }

   }

}

sub get
{
   my $self = shift;
   my $impl = $self->[0];   

   if (defined $impl){

     return  Net::ICal::icalvalue_as_ical_string($impl);

   }
}

1;
