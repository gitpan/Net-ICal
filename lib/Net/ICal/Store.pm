#!/usr/bin/perl
# -*- Mode: perl -*-
#======================================================================
# FILE: Store.pm
# CREATOR: eric 02 January 2000
#
# DESCRIPTION:
#   
#
#  $Id: Store.pm,v 1.2 2000/03/17 08:24:12 eric Exp $
#  $Locker:  $
#
# (C) COPYRIGHT 2000 Eric Busboom
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
# The Original Code is Store.pm. The Initial Developer of the Original
# Code is Eric Busboom
#
#======================================================================

package Net::ICal::Store;

sub new {
  my $package = shift;
  my $path = shift;
  my $nodelete = shift; #True if ical object should not be deleted in DESTROY; 
  my $self = [];


  die "Net::ICal::Store::new \"$path\" is not a directory" if (-e !path and ! -d $path);
  
  if (! -e $path){
    mkdir($path,0777) || die "Net::ICal::Store::new Can't make store directory \"$path\"";
    
  }
  
  $self->[0] = Net::ICal::icalstore_new($path);
    

  die "Net::ICal::Store::new::Couldn't open store for dir $path" if !$self->[0];

  bless $self,$package;
  return $self;
}

sub _impl
{
  my $self = shift;
  return $self->[0];
}

sub new_from_ref
{
  my $ref = shift;
  my $self = [];
  my $nodelete = shift;

  return undef if !$ref;

  $self->[0] = $ref;
  $self->[1] = $nodelete;

  bless $self,"Net::ICal::Store";

  return $self;
  
}

sub DESTROY {

  my $self = shift;
  my $impl = $self->_impl();

  return if !$self;
  return if !$self->_impl();

  Net::ICal::icalstore_free($impl) if !$self->[1];

}

sub add{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->_impl();

  return Net::ICal::icalstore_add_component($impl,$comp->_impl());

}

sub remove{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->_impl();

  return Net::ICal::icalstore_remove_component($impl,$comp->_impl());

}

sub select {
  my $self = shift;
  my $comp = shift;
  my $impl = $self->_impl();

  return Net::ICal::icalstore_select($impl,$comp->_impl());

}

sub clear {
  my $self = shift;
  my $comp = shift;
  my $impl = $self->_impl();

  return Net::ICal::icalstore_clear($impl,undef);

}

sub get_first {
  my $self = shift;
  my $impl = $self->_impl();
  my $type = shift;

  my $c = Net::ICal::icalstore_get_first_component($impl);

  return Net::ICal::Component::new_from_ref($c);
}

sub get_next {
  my $self = shift;
  my $impl = $self->_impl();
  my $type = shift;

  my $c = Net::ICal::icalstore_get_next_component($impl);

  return Net::ICal::Component::new_from_ref($c);

}


1;

