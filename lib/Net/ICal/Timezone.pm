#!/usr/bin/perl -w
# vi:sts=4:shiftwidth=4
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without
# express or implied warranty.  It may be used, redistributed and/or
# modified under the same terms as perl itself. ( Either the Artistic
# License or the GPL. )
#
# $Id$
#
# (C) COPYRIGHT 2000-2001, Reefknot developers.
#
# See the AUTHORS file included in the distribution for a full list.
#======================================================================

=head1 NAME

Net::ICal::Timezone -- class for representing VTIMEZONEs

=cut

package Net::ICal::Timezone;
use strict;

use base qw(Net::ICal::Component);

use Carp;
use Net::ICal::Property;
use Net::ICal::Util qw(:all);

=head1 DESCRIPTION


=head1 SYNOPSIS

  use Net::ICal::Timezone;

=cut

#============================================================================
sub new {
    my ($class, %args) = @_;

    my $self = &_create ($class, %args);

    return undef unless (defined $self);

    unless ($self->uid) {
    	$self->uid (Net::ICal::Util->create_uuid);
    }
    return undef unless ($self->validate);

    return $self;
}

#=================================================================================
=head2 new_from_ical ($text)

Takes iCalendar text as a parameter; returns a Net::ICal::Timezone object. 

=cut



#==================================================================================
# make sure that this object has the bare minimum requirements specified by the RFC,
my $count = 0;

sub validate {
    my ($self) = @_;
	
   
    return $self->SUPER::validate ($self);
}

# an internal function that sets up the object. 
sub _create {
    my ($class, %args) = @_;

    print "running create\n";
    my $map = {   # RFC2445 4.6.5 describes VTIMEZONE
        tzid => { 	# RFC2445 4.8.3.1 - REQUIRED, only once
            type => 'parameter',
    	    doc => 'unique identifier for this timezone',
 	        domain => 'param',
	        options => '',
	        value => undef,
        },
        lastmod => {  	# RFC2445 ? - optional, 1x only in VTIMEZONE
  	        type => 'parameter',
    	    doc => 'last time this item was modified',
	        domain => 'param',
	        options => '',
            value => undef,
        },
        tzurl => {  	# RFC2445 4.8.3.5 - optional, 1x only in VTIMEZONE
  	        type => 'parameter',
	        doc => 'a URL for finding the latest version of this VTIMEZONE',
    	    domain => 'param',
	        options => '',
            value => undef,
        },
        standard => {	# RFC2445 4.6.5 - required >=1x in VTIMEZONE
	        type => 'parameter',
	        doc => 'a set of standard timezone info',
	        value => undef,
            domain => 'ref',
            options => 'ARRAY',
   	    },
        daylight => {	# RFC2445 4.6.5 - required >=1x in VTIMEZONE
	        type => 'parameter',
	        doc => 'a set of daylight timezone info',
	        value => undef,
            domain => 'ref',
            options => 'ARRAY',
   	    },
        dtstart => {    # RFC2445 4.6.5? - optional in VTIMEZONE,
	        type => 'parameter',
	        doc => '',
	        domain => 'ref',
	        # TODO, BUG 424114: needs to be in UTC. how to enforce?
	        options => 'Net::ICal::Time',
	        value => undef,
   	    },
        tzoffsetto => {	# RFC2445 4.8.3.4 - optional in VTIMEZONE
	        type => 'parameter',
	        doc => 'UTC offset in use now in this timezone',
	        domain => 'param',
	        options => '',
	        value => undef,
   	    },
        tzoffsetfrom => {	# RFC2445 4.8.3.3 - optional in VTIMEZONE
	        type => 'parameter',
	        doc => 'UTC offset in use prior to the current offset in this tz',
	        domain => 'param',
	        options => '',
	        value => undef,
   	    },
   	    comment => {	# RFC2445 ? - optional multiple times in VTIMEZONE
	        type => 'parameter',
    	    doc => 'comment about this timezone',
	        domain => 'param',
	        options => '',
	        value => undef,
   	    },
   	    rdate => {	# RFC2445 ? - optional multiple times in VTIMEZONE
	        # TODO: this should point to another N::I data type
            type => 'parameter',
	        doc => 'recurrence date',
	        domain => 'param',
	        options => '',
	        value => undef,
   	    },
   	    rrule => {	# RFC2445 ? - optional multiple times in VTIMEZONE
	        # TODO: this should point to another N::I data type
	        type => 'parameter',
	        doc => 'a recurrence rule',
	        domain => 'param',
	        options => '',
	        value => undef,
   	    },
   	    tzname => {	# RFC2445 4.8.3.2 - optional multiple times in VTIMEZONE
	        type => 'parameter',
	        doc => 'a name for this timezone',
	        domain => 'param',
	        options => '',
	        value => undef,
   	    },
        # FIXME: handle x-properties. 
    };

    print "running new\n";
    my $self = $class->SUPER::new ('VTIMEZONE', $map, %args);

    return $self;
}

1;

=head1 SEE ALSO

More documentation pointers can be found in L<Net::ICal>.

=cut
