#!/usr/bin/perl -w
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. ) 
#
# $Id: ETJ.pm,v 1.21 2001/03/25 06:33:31 srl Exp $
#
# (C) COPYRIGHT 2000, Reefknot developers.
# 
# See the AUTHORS file included in the distribution for a full list. 
#======================================================================

package Net::ICal::ETJ;

BEGIN {
   @Net::ICal::ETJ::ISA = qw(Net::ICal::Component);
}

use Carp;
use strict;
use Net::ICal::Component;
use Net::ICal::Time;
use UNIVERSAL qw(isa);


my $count = 0;

=pod 

=head1 NAME

Net::ICal::ETJ-- iCalendar event, todo and journal entry base class

=head1 SYNOPSIS

  use Net::ICal::ETJ;
  my $c = new Net::ICal::ETJ(hash of arguments);


=head1 DESCRIPTION

Net::ICal::ETJ represents iCalendar events, todo items and
journal entries. It's a base class for N::I::Event, N::I::Todo,
and N::I::Journal. 

Casual users shouldn't ever need to actually make an ETJ object. If 
you think you do, read the source to find out how. ;)

=head1 SEE ALSO

Net::ICal::Event, Net::ICal::Todo, Net::ICal::Journal.

=cut

# make sure that this object has the bare minimum requirements
# specified by the RFC.

# TODO:
# according to http://www.imc.org/ietf-calendar/mail-archive/msg02603.html
# uid isn't required for iCal, just for iTIP. How do we handle this?
# (Suggestion: make Net::iTIP a child class, and have its new() routine
# validate UIDs. --srl)

sub validate {
   my ($class, $args) = @_;
	
   return undef unless defined ($args->{organizer});

   my $time = new Net::ICal::Time (gmtime);
   # make N::I::Time know it's UTC
   $time->{ISUTC} = 1;
   unless (defined $args->{uid}) {
      use Sys::Hostname; 
	  # for portability reasons; <arno.aalto@kolumbus.fi> pointed this out
	  my $host = hostname;	
	  
      chomp $host;
      $args->{uid} = substr ($time->as_ical, 1) . "-$$-" . $count++ . "\@$host";
   }

   # since DTSTAMP is required by the RFC, we'll create it
   # if it's not given to us. 
   unless (defined ($args->{dtstamp}) ) {
      $args->{dtstamp} = $time;
   }
	 
   return 1;
}

sub _create {
   	my ($foo, $class, %args) = @_;
	#use Data::Dumper; print Dumper @_;

   	my $map = {

		alarms => {   # RFC 4.6.6 - optional in VEVENT and VTODO.
	    	type => 'parameter',
         	doc => 'the alarms related to this event',
         	domain => 'ref',
         	options => 'ARRAY',
         	value => undef,
		},
		class => {		# RFC2445 4.8.1.3 - optional 1x in VEVENT, VTODO, VJOURNAL
	 		type => 'parameter',
		 	doc => 'who can see this?',
		 	domain => 'enum',
	 		options => [qw(PUBLIC PRIVATE CONFIDENTIAL)],
	 		value => undef,
			# this is *not* an access control system; this is the intention of
			# the calendar owner. see the RFC.
      	},
      	created => {   # RFC2445 4.8.7.1 - optional 1x in VEVENT, VTODO, VJOURNAL
	 		type => 'parameter',
	 		doc => 'when was this first created',
	 		domain => 'ref',
	 		options => 'Net::ICal::Time',
	 		value => undef,
      	},
      	description => {	# RFC2445 4.8.1.5 - optional 1x in VEVENT, VTODO,
							# VJOURNAL, VALARM - can occur more in VJOURNAL
	 		type => 'parameter',
	 		doc => 'more details about this event',
	 		domain => 'param',
			options => [qw(altrep language)],
	 		value => undef,
      	},
      	dtstart => {		# RFC2445 4.8.2.4 - optional in VTODO, VFREEBUSY,
							# VTIMEZONE; required in VEVENT; not specified in
							# VJOURNAL
	 		type => 'parameter',
	 		doc => '',
	 		domain => 'ref',
	 		# TODO: needs to be in UTC. how to enforce?
	 		options => 'Net::ICal::Time',
			value => undef,
      	},
      	dtend => {	# RFC2445 4.8.2.2 - optional in VEVENT or VFREEBUSY,
					# meaningless in VTODO or VJOURNAL 
	 		type => 'parameter',
	 		doc => 'when this event ends',
			domain => 'ref',
	 		options => 'Net::ICal::Time',
	 		value => undef,
      	},
      	duration => {	# RFC2445 4.8.2.5 - optional in VEVENT or VTODO, 
						# meaningless in VJOURNAL
	 		type => 'parameter',
	 		doc => 'how long this task lasts',
	 		domain => 'ref',
	 		options => 'Net::ICal::Duration',
	 		value => undef,
      	},
      	due => { 		# RFC2445 4.8.2.3 - optional in a VTODO, used nowhere else
	 		type => 'parameter',
	 		doc => 'when this TODO item is done',
	 		domain => 'ref',
	 		options => 'Net::ICal::Time',
	 		value => undef,
      	},
      	geo => {		# RFC2445 4.8.1.6 - optional in VEVENT or VTODO. 
	 		type => 'parameter',
	 		doc => '',
	 		#FIXME: must be a float pair (latitude;longitude) where event/todo is
	 		value => undef,
      	},
      	last_modified => {	# RFC2445 4.8.7.3 - optional in VEVENT, VTODO, VJOURNAL
	 		type => 'parameter',
	 		doc => '',
	 		domain => 'ref',
	 		# TODO: needs to be in UTC. how to enforce?
			# TODO: a server will need to keep track of this automatically. 
	 		options => 'Net::ICal::Time',
	 		value => undef,
      	},
      	location => {	# RFC2445 4.8.1.7 - optional in VEVENT or VTODO
	 		type => 'parameter',
	 		doc => '',
	 		domain => 'param',
			options => [qw(altrep language)],
	 		value => undef,
      	},
      	organizer => {	# RFC2445 4.8.4.3 - REQUIRED in VEVENT, VTODO,
						# VJOURNAL, VFREEBUSY
	 		type => 'parameter',
	 		doc => '',
	 		domain => 'ref',
	 		options => 'Net::ICal::Attendee',
	 		value => undef,
      	},
      	priority => {	# RFC2445 4.8.1.9 - optional in VEVENT or VTODO
	 		type => 'parameter',
	 		doc => 'How high a priority is this?',
	 		domain => '', 
			value => 0,
			# 0=undefined; 1=highest priority; 9=lowest priority, but CUAs
			# can use other schemes. See the RFC.
      	},
      	dtstamp => {	# RFC2445 4.8.7.2 - REQUIRED in VEVENT, VTODO,
						# VJOURNAL, VFREEBUSY
	 		type => 'parameter',
	 		doc => '',
			domain => 'ref',
	 		options => 'Net::ICal::Time',
	 		value => undef,
			# TODO: this is the date/time this object was created; should we
			# set it by default if the user doesn't set it?
			# Does this have to be in UTC?
      	},
      	status => {		# RFC2445 4.8.1.1 - optional in VEVENT, VTODO, and VJOURNAL.						
	 		type => 'parameter',
	 		doc => 'overall status or confirmation value',
	 		domain => 'enum',
	 		options => [qw(TENTATIVE CONFIRMED CANCELLED 
	 			NEEDS-ACTION IN-PROGRESS COMPLETED CANCELLED
				DRAFT FINAL CANCELLED)],
	            # FIXME: these differ radically for VEVENT, VTODO, and VJOURNAL. 
	 			# we need to override this in subclasses or something. 
         	value => undef,
      	},
      	summary => {	# RFC2445 4.8.1.12 - optional in VEVENT, VTODO,
						# VJOURNAL, and VALARM.
	 		type => 'parameter',
	 		doc => 'a one-line summary',
			options => [qw(altrep language)],
	 		value => undef,
      	},
      	transp => {		# RFC2445 4.8.2.7 - optional 1x in VEVENT 
	 		type => 'parameter',
	 		doc => 'does this event block out time',
	 		domain => 'enum',
	 		options => [qw(OPAQUE TRANSPARENT)],
	 		# an event is OPAQUE if it blocks out time, and TRANSPARENT
	 		# if it doesn't. 
			value => undef,
      	},
      	uid => {	# RFC2445 4.8.4.7 - REQUIRED in VEVENT, VTODO, VJOURNAL,
					# VFREEBUSY
	 		type => 'parameter',
	 		doc => 'global-unique identifier for a generated event',
		 	value => undef,
	 		# TODO: generate a globally-unique id here. 
			# This is much like an RFC822 message id.
      	},
      	url => {	# RFC2445 4.8.4.6 - optional 1x in VEVENT, VTODO, VJOURNAL,
					# VFREEBUSY. 
	 		type => 'parameter',
	 		doc => 'a url associated with this event',
	 		value => undef,
      	},
      	recurrence_id => { 	# RFC2445 4.8.4.4 - optional in any recurring
							# calendar component. 
	 		type => 'parameter',
	 		doc => 'which occurrence of a recurring event is this?',
 	 		# see 4.8.4.4 on this.	This keeps track of *which* Monday at 10am meeting
	 		# this one is. it's used together with UID.
	 		domain => 'ref',
	 		options => 'Net::ICal::Time',
	 		value => undef,
      	},
     	attach => { 	# RFC2445 4.8.1.1 - optional in VEVENT, VTODO,
						# VJOURNAL, VALARM
      	 	# FIXME: there can be one or more of these, and it should be a N::I::Attach
	 		type => 'parameter',
	 		doc => '',
	 		domain => 'ref',
	 		options => 'ARRAY',
	 		value => undef,
      	},
      	attendee => { 	# RFC2445 4.8.4.1 - optional in VEVENT, VTODO, VJOURNAL;
					  	# PROHIBITED in VFREEBUSY and VALARM
   	 		type => 'parameter',
	 		doc => 'who is coming to this meeting',
 	 		domain => 'ref',
	 		options => 'ARRAY',
	 		# FIXME: there can be more than one of these, a N::I::Attendee
	 		value => undef,
      	},
      	categories => { # RFC2445 4.8.1.2 - optional in VEVENT, VTODO, VJOURNAL 
	 		type => 'parameter',
	 		doc => 'ref',
	 		options => 'ARRAY', # there can be more than one of these, just text
	 		value => undef,
      	},
      	comment => {  	# RFC2445 4.8.1.4 - optional in VEVENT, VTODO, VJOURNAL,
						# VTIMEZONE, VFREEBUSY
	 		type => 'parameter',
	 		doc => '',
	 		domain => 'param',
			options => [qw(altrep param)],
	        # FIXME: there can be more than one of these in an event/todo/journal. 
	        # do they need to be ordered in an array?
	  		value => undef,
      	},
      	contact => {	# RFC2445 4.8.4.2 - optional in VEVENT, VTODO, VJOURNAL,
						# VFREEBUSY
	 		type => 'parameter',
	 		doc => 'who to contact about this event',
	 		# i'm really surprised this isn't an Attendee type. but i guess
		 	# it makes sense. 
	 		value => undef,
      	},
      	exdate => {		# RFC2445 4.8.5.1 - optional in any recurring component.
	 		type => 'parameter',
	 		doc => 'a 1-date exception to a recurrence rule',
	 		domain => 'ref',
	 		options => 'Net::ICal::Time',
	 		value => undef,
      	},
      	exrule => { # RFC2445 4.8.5.2 - optional in VEVENT, VTODO, VJOURNAL
			# should be a set of Net::ICal::Recurrence objects
	 		type => 'parameter',
	 		doc => 'A rule that defines the exceptions to a recurrence rule',
	 		domain => 'ref',
	 		options => 'ARRAY',
			value => undef,
      	},
      	request_status => { # RFC2445 4.8.8.2 - optional in VEVENT, VTODO,
							# VJOURNAL, VFREEBUSY
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
      	related_to => { 	# RFC2445 4.8.4.5 - optional multiple times in
							# VEVENT, VTODO, or VJOURNAL
	 		type => 'parameter',
	 		doc => ' other events/todos/journals this item relates to',
	 		domain => 'ref',
	 		options => 'ARRAY',   # could be a hash, i guess. 
	 		value => undef,
      	},
      	resources => { # RFC2445 4.8.1.10 - optional in VEVENT or VTODO 
			# TODO: only related to VEVENT or VTODO, not VJOURNAL; should
			# there be an error generated if someone requests this in a
			# VJOURNAL?
	 		type => 'parameter',
	 		doc => '',
	 		value => undef,
			# TODO: is this a Net::ICal::Attendee?
      	},
      	rdate => { # RFC2445 4.8.5.3 - optional in VEVENT, VTODO, VJOURNAL, VTIMEZONE 
			type => 'parameter',
	 		doc => 'define a set of dates as part of a recurrence set',
	 		domain => 'ref',
	 		options => 'ARRAY',
	 		value => undef,
 			# should be a set of N::I::Times, i think.
     	},
      	rrule => { 	# RFC2445 4.8.5.4 - optional multiple times in recurring
					# vVEVENT, VTODO, VJOURNALs. optional 1x in STANDARD or
					# DAYLIGHT parts of VTIMEZONE. 
			# should be a set of Net::ICal::Recurrence objects
	 		type => 'parameter',
	 		doc => 'a rule to describe when this event, todo, or journal repeats',
	 		domain => 'ref',
	 		options => 'ARRAY',
			value => undef,
      	},
      	sequence => {  # RFC2445 4.8.7.4 - optional in VEVENT, VTODO, VJOURNAL
	 		type => 'parameter',
	 		doc => 'version number of this event/todo/journal',
	 		# see 4.8.7.4. Whenever DTSTART, DTEND, DUE, RDATE, RRULE, 
	 		# EXDATE, EXRULE, or STATUS are changed, this has to be incremented.
			# starts at 0 and counts up. 
	 		# TODO: we should be handling this internally, not letting the user 
			# manipulate it. 
			value => undef,
      	}

		# TODO: look also at rfc2445 4.2.15, RELTYPE - is that something that should
		# go here?
		#
   }; 
   my $myclass = __PACKAGE__;
   my $self = $myclass->SUPER::new ($class, $map, %args);
   return $self;
}

1;
__END__

=head1 SEE ALSO

If you want to understand *how* this module works, read the source. You'll
need to understand how Class::MethodMapper works also. 
