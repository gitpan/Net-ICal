# FILE: Calendar.pm
# CREATOR: eric 02 January 2000
#
# DESCRIPTION:
#   
#
#  $Id: Calendar.pm,v 1.4 2000/05/24 04:41:32 eric Exp $
#  $Locker:  $
#
# (C) COPYRIGHT 2000, Eric Busboom, http://www.softwarestudio.org
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. ) 
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

