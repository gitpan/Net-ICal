#!/usr/bin/perl -w
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. ) 
#
# $Id: Freebusy.pm,v 1.4 2001/03/25 20:37:46 srl Exp $
#
# (C) COPYRIGHT 2000-2001, Reefknot developers.
#
# See the AUTHORS file included in the distribution for a full list. 
#======================================================================

package Net::ICal::Freebusy;

BEGIN {
   @Net::ICal::Freebusy::ISA = qw(Net::ICal::Component);
}

use Carp;
use strict;
use UNIVERSAL qw(isa);

use Net::ICal::Period;
use Net::ICal::Property;

# TODO: this documentation needs expanding. 
=pod 

=head1 NAME

Net::ICal::Freebusy -- Freebusy class

=head1 SYNOPSIS

  use Net::ICal::Freebusy;
  
  my $p = new Net::ICal::Period("19970101T120000","19970101T123000");
  my $p = new Net::ICal::Period("19970101T124500","19970101T130000");
  
  # syntax which works now
  my $f = new Net::ICal::Freebusy(freebusy => [$p], 
                                  organizer => 'alice@wonderland.com');

  # FIXME: you should be able to say this, but it doesn't work now
  my $f = new Net::ICal::Freebusy(freebusy => [$p, $q], 
                                  organizer => 'alice@wonderland.com');
                                  
=head1 DESCRIPTION

Net::ICal::Freebusy represents a list of time when someone's
free or busy. Freebusy elements can be used in three ways:

=over 4

=item * To request information about a user's open schedule slots 

=item * To reply to a request for free/busy information

=item * To publish a user's list of free/busy information. 
=back

=head1 BASIC METHODS

=head2 new (options_hash)

Creates a new Freebusy element. Arguments should be specified 
as elements in a hash. 

When making a request for information about a user's free/busy time,
arguments can be any of the following:

=over 4

=item * contact - who to contact about this 

=item * dtstart - beginning of the window of time we want info about

=item * dtend - end of the window of time we want info about. 

=item * duration - how large a block of time we want to know about. 

=item * dtstamp - when this request was created

=item * organizer - user who wants information about free/busy times

=item * uid - a unique identifier for this request. 

=item * url - a URL with more information about this request

=item * attendee - which users' schedules we want info about; an array of Attendee objects

=item * comment - a comment about this request. 

=item * freebusy - allowed but meaningless. 

=item * request_status - allowed but not relevant.

=back

When responding to a request for free/busy information, the arguments mean 
different things:

=over 4

=item * contact - who to contact about this list

=item * dtstart - allowed but irrelevant

=item * dtend - allowed but irrelevant

=item * duration - allowed but irrelevant

=item * dtstamp - when this response was created

=item * organizer - allowed but irrelevant

=item * uid - a unique identifier for this response. 

=item * url - a URL with more information about this response.

=item * attendee - the user responding to the request

=item * comment - a comment about this response.

=item * freebusy - an array of Durations that are free. Right now, only one Duration is allowed, This will be fixed.

=item * request_status - a number representing the success or failure of the request. See RFC2445 4.8.8.2.

=back

When publishing information about busy time to other users, the
parameters have the following meanings:

=over 4

=item * contact - who to contact about this list

=item * dtstart - Beginning date of this range of published free/busy time

=item * dtend - End date of this range of published free/busy time

=item * duration - allowed but irrelevant (?)

=item * dtstamp - when this information was published

=item * organizer - The calendar user associated with this free/busy info

=item * uid - a unique identifier for this publication of free/busy info. 

=item * url - a URL with more information about this published free/busy.

=item * attendee - allowed but irrelevant.

=item * comment - a comment about this publication.

=item * freebusy - an array of Durations that are free. Right now, only one Duration is allowed, This will be fixed.

=item * request_status - allowed but irrelevant.

=back

=cut

#============================================================================
sub new {
  my ($class, %args) = @_;

  # set FBTYPE to the default, BUSY, if not otherwise specified.
  # commented out because this property is supposed to show up on FREEBUSY lines
  #unless (defined $args{fbtype}) {
  #  $args{fbtype} = 'BUSY';
  #}


  return undef unless _validate ($class, \%args);
	
  return &_create ($class, %args);
}

#=================================================================================
=head2 new_from_ical ($text)

Takes iCalendar text as a parameter; returns a Net::ICal::Freebusy object. 

=cut

# new_from_ical is inherited from Net::ICal::Component.
# TODO: this needs a test case done to prove that it works. 


#==================================================================================
# make sure that this object has the bare minimum requirements specified by the RFC,
sub _validate {
	my ($class, $args) = @_;
	
	# fill these in later
	# like:
	# return undef unless $args{foo};

	return 1;
}

# an internal function that sets up the object. 
sub _create {
  my ($class, %args) = @_;

  my $map = {   # RFC2445 4.6.4 describes VFREEBUSY
    attendee => { 	# RFC2445 4.8.4.1 says this is PROHIBITED in VFREEBUSY;
                    # 4.6.4 says it's optional.
      type => 'parameter',
	  doc => 'who is coming to this meeting',
 	  domain => 'ref',
	  options => 'ARRAY',
	    # FIXME: there can be more than one of these, a N::I::Attendee
	  value => undef,
    },
    comment => {  	# RFC2445 4.8.1.4 - optional in VFREEBUSY
  	  type => 'parameter',
	  doc => '',
	  domain => 'param',
	  options => [qw(altrep param)],
	    # FIXME: there can be more than one of these in an event/todo/journal. 
	    # do they need to be ordered in an array?
	  value => undef,
    },
    contact => {	# RFC2445 4.8.4.2 - optional in VFREEBUSY
	  type => 'parameter',
	  doc => 'who to contact about this event',
	  # i'm really surprised this isn't an Attendee type. but i guess
	  # it makes sense. 
	  value => undef,
   	},
    dtstart => {		# RFC2445 4.8.2.4 - optional in VFREEBUSY,
	  type => 'parameter',
	  doc => '',
	  domain => 'ref',
	  # TODO: needs to be in UTC. how to enforce?
	  options => 'Net::ICal::Time',
	  value => undef,
   	},
    dtend => {	# RFC2445 4.8.2.2 - optional in VFREEBUSY
	  type => 'parameter',
	  doc => 'when this event ends',
	  domain => 'ref',
	  options => 'Net::ICal::Time',
	  value => undef,
   	},
   	duration => {	# XXX: RFC2445 4.8.2.5 says nothing about this;
      # 4.6.4's ABNF says that duration is relevant in VFREEBUSY. Who's right?
	  type => 'parameter',
	  doc => 'how long this task lasts',
	  domain => 'ref',
	  options => 'Net::ICal::Duration',
	  value => undef,
   	},
    dtstamp => {	# RFC2445 4.8.7.2 - REQUIRED in VFREEBUSY
                    # XXX: 4.6.4's ABNF says this is optional. hm?
	  type => 'parameter',
	  doc => '',
	  domain => 'ref',
	  options => 'Net::ICal::Time',
	  value => undef,
	  # TODO: this is the date/time this object was created; should we
	  # set it by default if the user doesn't set it?
	  # Does this have to be in UTC?
   	},
    freebusy => {
	  type => 'parameter',
	  doc => 'one or more Net::ICal::Periods',
	  domain => 'ref',
	  options => 'ARRAY',
      # TODO: we need to support multiple FREEBUSY lines, as well as multiple
      # Periods inside each FREEBUSY line. This very well might be an array
      # of Net::ICal::FreebusyItem objects or something. Thoughts?
      # TODO: we need to be able to output lines like:
      # FREEBUSY;VALUE=PERIOD:19971015T050000Z/PT8H30M,19971015T160000Z/PT5H30M
    },
   organizer => {	# RFC2445 4.8.4.3 - REQUIRED in VFREEBUSY
                    # XXX: 4.6.4's ABNF says this is OPTIONAL. hm?
	  type => 'parameter',
	  doc => '',
	  domain => 'ref',
	  options => 'Net::ICal::Attendee',
	  value => undef,
   	},
    request_status => { # RFC2445 4.8.8.2 - optional in VFREEBUSY
	  type => 'parameter',
	  doc => 'how successful have we been at scheduling this',
	  value => undef,
	    # This is a varying-granularity field; read the RFC.
	    # 1.x = preliminary success, pending completion
	 	# 2.x = request completed successfully, possibly with a fallback.
	 	# 3.x = request failed, syntax or semantic error in client req format
	 	# 4.x = scheduling error; some kind of failure in the scheduling system.
	 	# Values can look like "x.y.z" to give even more granularity.
	 	# TODO: I think we have to define our own error subcodes. --srl
    },
    uid => {	# RFC2445 4.8.4.7 - REQUIRED in VFREEBUSY
                # XXX: 4.6.4 claims this is optional. ????
	  type => 'parameter',
	  doc => 'global-unique identifier for a generated event',
	  value => undef,
	  # TODO: generate a globally-unique id here. 
	  # This is much like an RFC822 message id.
    },
    url => {	# RFC2445 4.8.4.6 - optional 1x in VFREEBUSY. 
	  type => 'parameter',
	  doc => 'a url associated with this event',
	  value => undef,
    },

  };

  my $self = $class->SUPER::new ('VFREEBUSY', $map, %args);

  return $self;
}

# TODO:
# Food for thought, from RFC2445 4.6.4:
#   When present in a "VFREEBUSY" calendar component, the "DTSTART" and
#   "DTEND" properties SHOULD be specified prior to any "FREEBUSY"
#   properties. In a free time request, these properties can be used in
#   combination with the "DURATION" property to represent a request for a
#   duration of free time within a specified window of time.
#
# as_ical methods currently don't let us specify the output order. They'll
# need to in order for us to be RFC-compliant here. 

1;
