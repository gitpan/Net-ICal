#!/usr/bin/perl
# -*- Mode: perl -*-
#======================================================================
# FILE: Property.pm
# CREATOR: eric 16 August 1999
#
# DESCRIPTION:
#   
#
#  $Id: Property.pm,v 1.5 2000/04/04 17:50:28 eric Exp $
#  $Locker:  $
#
# (C) COPYRIGHT 1999 Eric Busboom
# http://www.softwarestudio.org 
#
# The contents of this file are subject to the Mozilla Public License
# Version 1.0 (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# http://www.mozilla.org/MPL/
# 
# Software distributed under the License is distributed on an "AS IS"
# basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
# the License for the specific language governing rights and
# limitations under the License.
# 
# The Original Code is Property.pm. The Initial Developer of the Original
# Code is Eric Busboom
#
#======================================================================


package Net::ICal::Property;
use Net::ICal::Value;

sub new{
   my $self = {};
   my $package = shift;
   my $arg = shift;
   
   my $p = Net::ICal::icalproperty_new($arg);
   
   $self->{'impl'} = $p;

   bless $self, $package;

   Net::ICal::Property::_add_elements($self,\@_);

   return self; 
}

sub clone{
  my $orig = shift;

   my $p = Net::ICal::icalproperty_new_clone($orig->_impl());
   
   return new_from_ref($p);
}

sub new_from_string{
   my $package = shift;
   my $arg = shift;
 
   my $p = Net::ICal::icalproperty_new_from_string($arg);
   
   return new_from_ref($p);
}


sub new_from_ref{
   my $self = {};
   my $prop_ref = shift;

   $self->{'impl'} = $prop_ref;

   return undef if !$prop_ref;

   my $value_type = Net::ICal::icalproperty_isa($prop_ref);

   my $type_name = Net::ICal::icalenum_property_kind_to_string($value_type);


   my $ucf = join("",map {ucfirst(lc($_));}  split(/-/,$type_name));

   $ucf =~ s/X_property/X/;


   my $package = "Net::ICal::Property::".$ucf;

   return bless $self, $package;
}



sub as_ical_string{

  my $self= shift;
  
  my $str = Net::ICal::icalproperty_as_ical_string($self->_impl());

}

sub type {
}

sub isa_property{
}

sub get_parameter {
}

sub set_parameter {
}

sub remove_parameter {
}

#sub set_value{
#}

sub get_value_ref{
  my $self = shift;
  my $impl = $self->_impl();

  my $value_ref = Net::ICal::icalproperty_get_value($impl);


  return Net::ICal::Value::new_from_ref($value_ref);
}

sub _add_elements {

  my $self = shift;
  my $arrayref = shift;

  my $e;
  while( $e = shift @{$arrayref}) {

    $self->add($e);

  }
}

sub add { 
  my $self = shift;
  my $impl = $self->_impl();
  my $part = undef;

  while ($part = shift) {
    next if $part eq undef;

    if ($part ne undef and
        (ref $part) ne undef and
	Net::ICal::icalparameter_isa_parameter($part->_impl)) { 
      
      Net::ICal::icalproperty_add_parameter($impl,$part->_impl());

    } else {
      $self->set_value($part);
    }
  }

}


sub _impl {

  return $_[0]->{'impl'};
}

sub DESTROY {

  my $self = shift;

  return if $self->{'nofree'};
  return if !$self->_impl();

  print "FREEING:\n".$property->as_ical_string();

  Net::ICal::icalproperty_free($self->_impl());

}


package Net::ICal::Property::X; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;
   my $name = shift;
   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_X_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   Net::ICal::icalproperty_set_x_name($p,$name);

   return bless $self, $package;
}

sub get_x_name {
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalproperty_get_x_name($impl);

}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}




# Everything below this line is machine generated. Do not edit. 

package Net::ICal::Property::Method; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_METHOD_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_METHOD_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::LastModified; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_LASTMODIFIED_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIME_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Uid; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_UID_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Prodid; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_PRODID_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Status; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_STATUS_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Description; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_DESCRIPTION_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Duration; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_DURATION_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DURATION_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Categories; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_CATEGORIES_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Version; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_VERSION_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Tzoffsetfrom; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_TZOFFSETFROM_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_UTCOFFSET_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Rrule; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_RRULE_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_RECUR_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Attendee; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_ATTENDEE_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_CALADDRESS_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Contact; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_CONTACT_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::RelatedTo; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_RELATEDTO_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Organizer; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_ORGANIZER_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_CALADDRESS_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Comment; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_COMMENT_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Trigger; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_TRIGGER_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TRIGGER_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::XLicError; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_XLICERROR_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Class; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_CLASS_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Tzoffsetto; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_TZOFFSETTO_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_UTCOFFSET_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Transp; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_TRANSP_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Sequence; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_SEQUENCE_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_INTEGER_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Location; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_LOCATION_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::RequestStatus; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_REQUESTSTATUS_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_STRING_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Exdate; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_EXDATE_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEDATE_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Tzid; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_TZID_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Resources; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_RESOURCES_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Tzurl; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_TZURL_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_URI_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Repeat; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_REPEAT_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_INTEGER_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Priority; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_PRIORITY_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_INTEGER_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Freebusy; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_FREEBUSY_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_PERIOD_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Dtstart; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_DTSTART_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEDATE_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::RecurrenceId; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_RECURRENCEID_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEDATE_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Summary; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_SUMMARY_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Dtend; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_DTEND_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEDATE_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Tzname; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_TZNAME_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Rdate; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_RDATE_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEPERIOD_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Url; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_URL_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_URI_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Attach; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_ATTACH_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_ATTACH_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::XLicClustercount; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_XLICCLUSTERCOUNT_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_INTEGER_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Exrule; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_EXRULE_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_RECUR_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Query; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_QUERY_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_QUERY_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::PercentComplete; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_PERCENTCOMPLETE_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_INTEGER_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Calscale; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_CALSCALE_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Created; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_CREATED_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIME_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Geo; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_GEO_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_GEO_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Completed; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_COMPLETED_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIME_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Dtstamp; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_DTSTAMP_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIME_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Due; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_DUE_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_DATETIMEDATE_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}


package Net::ICal::Property::Action; 
use Net::ICal::Property;
@ISA=qw(Net::ICal::Property);
sub new
{
   my $package = shift;

   my $p = Net::ICal::icalproperty_new($Net::ICal::ICAL_ACTION_PROPERTY);
   my $self = Net::ICal::Property::new_from_ref($p);

   $self->_add_elements(\@_);

   return bless $self, $package;
}

sub set_value
{
   my $self = shift;
   my $v = shift;

   my $impl = $self->_impl();


   if ( ref $v && Net::ICal::icalvalue_isa_value($v->_impl())){
      Net::ICal::icalproperty_set_value($impl,$v->_impl);
   } else { 
      my $value = Net::ICal::icalvalue_new_from_string($Net::ICal::ICAL_TEXT_VALUE,$v);
      die if !$impl;
      Net::ICal::icalproperty_set_value($impl,$value) unless !$value;
   }

}

sub get_value
{
   my $self = shift;
   my $impl = $self->_impl();   

   if (defined $impl){
     my $value = Net::ICal::icalproperty_get_value($impl);
     return "" if !$value;
     return  Net::ICal::icalvalue_as_ical_string($value);
   } else {
      return "";
   }
}

1;
