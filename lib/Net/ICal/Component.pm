#!/usr/bin/perl
# -*- Mode: perl -*-
#======================================================================
# FILE: Component.pm
# CREATOR: eric 16 August 1999
#
# DESCRIPTION:
#   
#
#  $Id: Component.pm,v 1.5 2000/03/31 07:48:43 eric Exp $
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
# The Original Code is Component.pm. The Initial Developer of the Original
# Code is Eric Busboom
#
#======================================================================

package Net::ICal::Component;
use Net::ICal;
use Carp;

sub new {

  my $package = shift;
  my $string_r = shift;
  my $self = {}; 
  
  # HACK. Oddly, this will fail if you use "undef $\; $in =<>" to
  # slurp up a whole file into a string. I suspect that it interferes
  # with the flex lexer, but I don't really know.

  my $c = Net::ICal::icalparser_parse_string($$string_r); 

  return Net::ICal::Component::new_from_ref($c);
  
}

sub new_from_ref{
   my $comp_ref = shift;
   my $self = {}; 

#Net::ICal::icalproperty_as_ical_string($comp_ref);

   return undef if !$comp_ref;

   my $value_type = Net::ICal::icalcomponent_isa($comp_ref);
   my $type_name = Net::ICal::icalenum_component_kind_to_string($value_type);

   confess "Unknown component type: \"$type_name\" " if !$type_name;

   my $ucf = join("",map {ucfirst(lc($_));}  split(/-/,$type_name));

   my $package = "Net::ICal::Component::".$ucf;

   $self->{'impl'} = $comp_ref;

   bless $self, $package;

   return $self;
}


sub _impl{

  my $self = shift;

  return $self->{'impl'};
}

sub clone {
  my $self = shift;
  my $impl = $self->_impl();

  my $c = Net::ICal::icalcomponent_new_clone($impl);

  return Net::ICal::Component::new_from_ref($c);
}

sub type {
  my $self = shift;
  my $impl = $self->_impl();

  my $type = Net::ICal::icalcomponent_isa($impl);
  
  return Net::ICal::icalenum_component_kind_to_string($type);
}

sub is_valid {
  my $self = shift;
  my $impl = $self->_impl();
}


sub _add_elements{

  my $self = shift;
  my $arrayref = shift;

  my $e;
  while( $e = shift @{$arrayref}) {

    $self->add($e);

  }
}

sub remove {
  die "Not Implemented";
}

sub add {

  my $self = shift;
  my $impl = $self->_impl();
  my $part;

  while($part = shift){
    next if $part eq undef;
    if ((ref $part) ne undef  and  Net::ICal::icalcomponent_isa_component($part->_impl())) {
      $part->{'nofree'}++;
      Net::ICal::icalcomponent_add_component($impl,$part->_impl());     
    } elsif ((ref $part) ne undef  and  Net::ICal::icalproperty_isa_property($part->_impl)) { 
      $part->{'nofree'}++;
      Net::ICal::icalcomponent_add_property($impl,$part->_impl());
    }
  }
}

sub as_ical_string {
  
  my $self = shift;

  return Net::ICal::icalcomponent_as_ical_string($self->_impl());

}

sub properties{
  my $self = shift;
  my $type = shift;
  my @array;
  my $p;

  if ($type){
    $prop_kind = Net::ICal::icalenum_string_to_property_kind($type);
  } else {
    $prop_kind = $Net::ICal::ICAL_ANY_PROPERTY;
  }

 
  for($p = Net::ICal::icalcomponent_get_first_property($self->_impl(),$prop_kind);
      $p != undef;
      $p = Net::ICal::icalcomponent_get_next_property($self->_impl(),$prop_kind)
     ) 
  {
    my $prop = Net::ICal::Property::new_from_ref($p);

    push (@array, $prop);
  }

  return @array;
}

sub components{
  my $self = shift;
  my $type = shift;

  my @array;
  my $c;

  my $comp_kind;

  if ($type){
    $comp_kind = Net::ICal::icalenum_string_to_component_kind($type);
  } else {
    $comp_kind = $Net::ICal::ICAL_ANY_COMPONENT;
  }

  for($c = Net::ICal::icalcomponent_get_first_component($self->_impl(),$comp_kind);
      $c != undef;
      $c = Net::ICal::icalcomponent_get_next_component($self->_impl(),$comp_kind)
     ) 
  {
    my $comp = Net::ICal::Component::new_from_ref($c);
    push (@array, $comp);
  }


  return @array;
}

sub convert_errors {
  
  my $self = shift;

  return Net::ICal::icalcomponent_convert_errors($self->_impl());

}

sub strip_errors {
  
  my $self = shift;

  return Net::ICal::icalcomponent_strip_errors($self->_impl());

}

sub count_errors {
  
  my $self = shift;

  return Net::ICal::icalcomponent_count_errors($self->_impl());

}

sub check_restrictions {
  
  my $self = shift;

  return Net::ICal::icalrestriction_check($self->_impl());

}

sub DESTROY {
  my $self = shift;

  return if !$self;
  return if !$self->impl();
  return if Net::ICal::icalcomponent_get_parent($self->_impl());

  print "Free: ".$self->_impl()."\n";

  Net::ICal::icalcomponent_free($self->_impl());
  
}

# Everything below this line is machine generated. Do not edit. 

# VCALENDAR 
package Net::ICal::Component::Vcalendar;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VCALENDAR_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VEVENT 
package Net::ICal::Component::Vevent;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VEVENT_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VTODO 
package Net::ICal::Component::Vtodo;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VTODO_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VJOURNAL 
package Net::ICal::Component::Vjournal;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VJOURNAL_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VFREEBUSY 
package Net::ICal::Component::Vfreebusy;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VFREEBUSY_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VTIMEZONE 
package Net::ICal::Component::Vtimezone;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VTIMEZONE_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# XSTANDARDTIME 
package Net::ICal::Component::Xstandardtime;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_XSTANDARDTIME_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# XDAYLIGHTSAVINGSTIME 
package Net::ICal::Component::Xdaylightsavingstime;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_XDAYLIGHTSAVINGSTIME_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VALARM 
package Net::ICal::Component::Valarm;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VALARM_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# XAUDIOALARM 
package Net::ICal::Component::Xaudioalarm;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_XAUDIOALARM_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# XDISPLAYALARM 
package Net::ICal::Component::Xdisplayalarm;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_XDISPLAYALARM_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# XEMAILALARM 
package Net::ICal::Component::Xemailalarm;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_XEMAILALARM_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# XPROCEDUREALARM 
package Net::ICal::Component::Xprocedurealarm;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_XPROCEDUREALARM_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# X 
package Net::ICal::Component::X;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_X_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VSCHEDULE 
package Net::ICal::Component::Vschedule;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VSCHEDULE_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VQUERY 
package Net::ICal::Component::Vquery;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VQUERY_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VCAR 
package Net::ICal::Component::Vcar;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VCAR_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# VCOMMAND 
package Net::ICal::Component::Vcommand;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_VCOMMAND_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# XLICINVALID 
package Net::ICal::Component::Xlicinvalid;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_XLICINVALID_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# ANY 
package Net::ICal::Component::Any;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_ANY_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}

# XRoot
package Net::ICal::Component::Xroot;
@ISA=qw(Net::ICal::Component);

sub new
{
   my $package = shift;
   my $c = Net::ICal::icalcomponent_new($Net::ICal::ICAL_XROOT_COMPONENT);

   my $self = Net::ICal::Component::new_from_ref($c);
   Net::ICal::Component::_add_elements($self,\@_);

   # Self is blessed in new_from_ref

   return $self; 

}
