#!/usr/bin/perl
# -*- Mode: perl -*-
#======================================================================
# FILE: Calendar.pm
# CREATOR: eric 02 January 2000
#
# DESCRIPTION:
#   
#
#  $Id: Calendar.pm,v 1.2 2000/03/17 08:24:12 eric Exp $
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
# The Original Code is Calendar.pm. The Initial Developer of the Original
# Code is Eric Busboom
#
#======================================================================

package Net::ICal::Calendar;

use Net::ICal::Cluster;
use Net::ICal::Store;

sub new{
  my $package = shift;
  my $path = shift;
  my $self = [];
  my $nodelete = shift; # True if libical object should not be deleted in DESTROY


  die "Net::ICal::Store::new \"$path\" is not a directory" if (-e !path and ! -d $path);
  
  $self->[0] = Net::ICal::icalcalendar_new($path);
  $self->[1] = $nodelete;
    
  die "Net::ICal::Store::new::Couldn't open calendar for dir \"$path\"" if !$self->[0];

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
}


sub DESTROY {
  my $self = shift;

  return if !$self;
  return if !$self->_impl();
  Net::ICal::icalcalendar_free($self->_impl());
}

sub lock{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->[0];
}

sub unlock{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->[0];
}

sub islocked{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->[0];
}

sub ownlock{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->[0];
}

sub get_booked{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->[0];

  my $store = Net::ICal::icalcalendar_get_booked($impl);

  return Net::ICal::Store::new_from_ref($store,1);
}

sub get_incoming{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->[0];

  my $store = Net::ICal::icalcalendar_get_incoming($impl);

  return Net::ICal::Cluster::new_from_ref($store,1);

}

sub get_properties{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->[0];

  my $store = Net::ICal::icalcalendar_get_properties($impl);

  return Net::ICal::Cluster::new_from_ref($store,1);
}

sub get_freebusy{
  my $self = shift;
  my $comp = shift;
  my $impl = $self->[0];

  my $store = Net::ICal::icalcalendar_get_freebusy($impl);

  return Net::ICal::Cluster::new_from_ref($store,1);

}




1;

