#!/usr/bin/perl -w
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. ) 
#
# $Id: Todo.pm,v 1.7 2001/03/23 17:42:47 shutton Exp $
#
# (C) COPYRIGHT 2000, Eric Busboom, http://www.softwarestudio.org
#
#======================================================================

package Net::ICal::Todo;

BEGIN {
   @Net::ICal::Todo::ISA = qw(Net::ICal::ETJ);
}

use Carp;
use strict;
use UNIVERSAL qw(isa);
use Net::ICal::ETJ;


# TODO: work on this documentation.

=head1 NAME

Net::ICal::Todo -- Todo class

=head1 SYNOPSIS

  use Net::ICal::Todo;
  my $c = new Net::ICal::Todo();

  }

=head1 DESCRIPTION

Net::ICal::Todo represents something someone needs to get done.   


=head1 BASIC METHODS

=head2 new($args)

Construct a new Todo. Parameters are in a hash.
Meaningful parameters are:


=head2 REQUIRED

=over 4

=item * organizer - a Net::ICal::Attendee for who's organizing this meeting. 

=back

=head2 OPTIONAL

=over 4

=item * dtstart - a Net::ICal::Time for when this Todo starts.

=item * duration - a Net::ICal::Duration; how long this thing will take
to do. 

=item * alarms - an array of Net::ICal::Alarm objects; reminders about
doing this item. 

=item * class - PUBLIC, PRIVATE, or CONFIDENTIAL - the creator's intention
about who should see this Todo.

=item * created - a Net::ICal::Time saying when this object was created.

=item * description - a hash with at least a content key, maybe an altrep 
and a language key. Content is a description of this Todo. 

=item * dtstamp - when this Todo was created. Will be set to the current 
time unless otherwise specified.

=item * geo - a pair of real numbers--- the latitude and longitude of 
this Todo.

=item * last_modified - a Net::ICal::Time specifying the last time this 
object was changed.

=item * location - a hash for where this Todo is taking place. The 
content key points to a string about the location; the altrep key gives 
an alternate representation, for example a URL.

=item * priority - a number from 0 (undefined) to 1 (highest) to 
9 (lowest) representing how important this event is.

=item * status - NEEDS-ACTION, IN-PROGRESS, COMPLETED, or CANCELLED; 
the status of this todo item.

=item * summary - a one-line summary of this Todo. If you need more 
space, use the description parameter.

=item * uid - a globally unique identifier for this event. Will be created
automagically.

=item * url - a URL for this Todo. Optional.

=item * attach - a Net::ICal::Attach - attached file for this Todo. 

=item * attendee - who's going to be at this meeting; an array of 
Net::ICal::Attendee objects.

=item * categories - what categories this event falls into. Make up 
your own categories. Optional.

=item * comment - a hash like that for description (above), comments 
on this Todo item.

=item * contact - a string describing who to contact about this Todo.

=item * request_status - how successful we've been at scheduling this Todo 
so far. Values can be integers separated by periods. 1.x.y is a preliminary 
success, 2.x.y is a complete successful request, 3.x.y is a failed request 
because of bad iCal format, 4.x.y is a calendar server failure. 

=item * related_to - an array of other Event, Todo, or Journal objects this 
Todo is related to. 

=item * resources - resources (such as an overhead projector) required for 
doing this task.

=item * sequence - an integer that starts at 0 when this object is 
created and is incremented every time the object is changed. 

=back

=head2 RECURRING TASKS

=over 4

=item * recurrence_id - if this task occurs multiple times, which occurrence of
it is this particular task?

=item * rdate - an array of Net::ICal::Time objects describing repeated occurrences
of this task. 

=item * rrule - an array of Net::ICal::Recurrence objects telling when
this task repeats. 

=item * exdate - a Net::ICal::Time giving a single-date exception to a 
recurring task.

=item * exrule - an array of  Net::ICal::Recurrence objects giving a 
recurring exception to a recurring task.

=back

=cut



sub new {
    my ($class, %args) = @_;
   
	# do some validation here

	return undef unless validate ($class, \%args);
	
	my $self = &_create ($class, %args);
	bless $self, $class;

   	return $self;
		
}


# make sure that this object has the bare minimum requirements
# specified by the RFC.

sub validate {
	my ($class, $args) = @_;
	
	# fill these in later
	# like:
	# return undef unless $args{foo};

	# make sure that ETJ has validated these args too. 
	return undef unless $class->SUPER::validate($args);
	
	return 1;
}



sub _create {
   	my ($class, %args) = @_;

	# set up a standard ETJ object. Note that since we're
	# calling _create, not new(), we don't validate %args right away.

    # don't pass in the %args yet, since we haven't created the
    # TODO specific bits. Passing %args now would result in those
    # keys not being set.
    my $self = $class->SUPER::_create ('VTODO');

	bless $self, $class;

	# FIXME: the above approach means we never get to merge these
	# map elements into the map. This is Bad.

	# add new elements to the map. 
   	my $map = {	
     	percent_complete => { # RFC2445 4.8.1.8 - optional in a VTODO 
	 		type => 'parameter',
	 		doc => 'how completed this task is',
	 		value => undef, 
      	},
  	  	due => { # RFC2445 4.8.2.3 - optional in a VTODO 
	 		type => 'parameter',
	 		doc => 'when this has to be done',
			domain => 'ref',
			options => 'Net::ICal::Time',
			value => undef, 

      	},
  	};


    # set up the new map.

    $self->set_map(%$map);
    $self->set (%args);

    # use Data::Dumper; print Dumper $self;

	return $self;
}

1;
