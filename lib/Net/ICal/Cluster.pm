#!/usr/bin/perl
# -*- Mode: perl -*-
#======================================================================
# FILE: Cluster.pm
# CREATOR: eric 02 January 2000
#
# DESCRIPTION:
#   
#
#  $Id: Cluster.pm,v 1.2 2000/03/17 08:24:12 eric Exp $
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
# The Original Code is Cluster.pm. The Initial Developer of the Original
# Code is Eric Busboom
#
#======================================================================

package Net::ICal::Cluster;


sub new 
{
  my $package = shift;
  my $path = shift;
  my $self = [];
  my $nodelete = shift; # True if libical object should not be deleted in DESTROY

  $self->[0] = Net::ICal::icalcluster_new($path);
  $self->[1] = $nodelete;

  if(!$self->[0] ){
    return undef;
  }

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

  bless $self,"Net::ICal::Cluster";

  return $self;  
}

sub DESTROY
{
  my $self = shift;

  return if !$self or !$self->_impl(); # HACK. Who is calling with a NULL cluster?

  return if ($self->[1]);

  Net::ICal::icalcluster_free($self->_impl());
}

sub load
{
  my $self = shift;
  my $path = shift;
}

sub mark
{
  my $self = shift;

#  Net::ICal::icalcluster_mark($self->_impl());
}

sub commit
{
  my $self = shift;
  Net::ICal::icalcluster_commit($self->_impl());
}


sub add
{
  my $self = shift;
  my $comp = shift;

  return Net::ICal::icalcluster_add_component($self->_impl(),$comp->_impl());
}

sub remove
{
  my $self = shift;
  my $comp = shift;

  return Net::ICal::icalcluster_remove_component($self->_impl(),$comp->_impl());

}

sub count
{
  my $self = shift;

  return Net::ICal::icalcluster_count($self->_impl());

}

sub current
{
  my $self = shift;
  my $comp = Net::ICal::icalcluster_get_current_component($self->_impl());
							  
  return Net::ICal::Component::new_from_ref($comp);
							  
}

sub first
{
  my $self = shift;
  my $type = shift;

  my $kind;

  if ($type){
    $kind = Net::ICal::icalenum_string_to_component_kind($type);
  } else {
    $kind = $Net::ICal::ICAL_ANY_COMPONENT;
  }

  my $comp = Net::ICal::icalcluster_get_first_component($self->_impl(),$kind);

  return undef if !$comp;

  return Net::ICal::Component::new_from_ref($comp);
}

sub next
{
  my $self = shift;
  my $type = shift;

  my $kind;

  if ($type){
    $kind = Net::ICal::icalenum_string_to_component_kind($type);
  } else {
    $kind = $Net::ICal::ICAL_ANY_COMPONENT;
  }

  my $comp = Net::ICal::icalcluster_get_next_component($self->_impl(),$kind);

  return undef if !$comp;

  return Net::ICal::Component::new_from_ref($comp);
}

1;

