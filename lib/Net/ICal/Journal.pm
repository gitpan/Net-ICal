#!/usr/bin/perl -w
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. ) 
#
# $Id: Journal.pm,v 1.2 2001/03/25 18:54:53 srl Exp $
#
# (C) COPYRIGHT 2000, Reefknot developers.
# 
# See the AUTHORS file included in the distribution for a full list. 
#======================================================================

package Net::ICal::Journal; 
BEGIN {
   @Net::ICal::Journal::ISA = qw(Net::ICal::ETJ);
}

use Carp;
use strict;
use UNIVERSAL qw(isa);
use Net::ICal::ETJ;

=pod 

=head1 NAME

Net::ICal::Journal -- Journal class

=head1 SYNOPSIS

  use Net::ICal::Journal;
  my $c = new Net::ICal::Journal(optionhash); 

=head1 DESCRIPTION

Net::ICal::Journal represents Journal events: things someone did,
perhaps. 

=pod

=head1 BASIC METHODS

=head2 new(optionhash)

Makes a new Journal object, given a hash of parameters. RFC-valid parameters
are below. 

USAGE NOTE: We're working on describing *how* these get used (semantics).
Read the source for this module if you're looking for a parameter that's
in the RFC for VJOURNALs and isn't listed here. We probably had a question
about whether it was really useful for Journal objects.

=head2 REQUIRED

=over 4

=item * organizer - a Net::ICal::Attendee for who's organizing this meeting. 

=back


=head2 OPTIONAL

=over 4

=cut

#=item * dtstart - a Net::ICal::Time for when you started this Journal item.
# XXX: DTSTART isn't really specified in the RFC; I think it's meaningful,
# but better not to give people the option to use it unless it means
# something to other calendar implementations.

=pod

=item * class - PUBLIC, PRIVATE, or CONFIDENTIAL - the creator's intention
about who should see this Journal. This is B<not> a binding access-control
mechanism. 

=item * created - a Net::ICal::Time saying when this object was created.

=item * description - a hash with at least a content key, maybe an altrep 
and a language key. Content is a description of this Journal.

=cut

# XXX: for journals, there can be more than one DESCRIPTION item. 
# See RFC2445 4.8.1.5.

=pod

=item * dtstamp - when this Journal was created. Will be set to the current 
time unless otherwise specified.

=item * last_modified - a Net::ICal::Time specifying the last time this 
object was changed.

=item * status - DRAFT, FINAL, or CANCELLED; 
the status of this journal item.

=item * summary - a one-line summary of this Journal. If you need more 
space, use the description parameter.

=item * uid - a globally unique identifier for this event. Will be created
automagically unless you specify it. 

=item * url - a URL for this Journal. Optional.

=item * attach - a Net::ICal::Attach - attached file for this Journal. 

=item * attendee - an array of Net::ICal::Attendee objects; people who were
relevant to this Journal item. 

=item * categories - an array: what categories this event falls into. Make up 
your own categories. 

=item * comment - a hash like that for description (above); comments 
on this Journal item.

=item * contact - a string describing who to contact about this Journal.

=cut

# This is allowed by the RFC, but I'm not sure what it means to Journal
# objects, so I'm excluding it. 
#=item * request_status - how successful we've been at scheduling this Todo 
#so far. Values can be integers separated by periods. 1.x.y is a preliminary 
#success, 2.x.y is a complete successful request, 3.x.y is a failed request 
#because of bad iCal format, 4.x.y is a calendar server failure. 

=pod

=item * related_to - an array of other Event, Todo, or Journal objects this 
Journal is related to. 

=cut
# XXX: how do we express related_to in iCal? with UIDs?

=pod

=item * sequence - an integer that starts at 0 when this object is 
created and is incremented every time the object is changed. 

=back

=head2 RECURRING TASKS

=over 4

=item * recurrence_id - if this journal occurs multiple times, which 
occurrence of it is this particular journal?

=item * rdate - an array of Net::ICal::Time objects describing repeated 
occurrences of this journal. 

=item * rrule - an array of Net::ICal::Recurrence objects telling when
this journal repeats; "every Wednesday at 3pm," for example. 

=item * exdate - a Net::ICal::Time giving a single-date exception to a 
recurring journal.

=item * exrule - an array of  Net::ICal::Recurrence objects giving a 
recurring exception to a recurring journal. "Every Wednesday except the
first Wednesday of the month" is an example. 

=back

=cut


sub new {
   	my ($class, %args) = @_;
	# do some validation here

	return undef unless _validate ($class, \%args);

   	return &_create ($class, %args);
}


# TODO: someone needs to verify that new_from_ical works for Journals. 
=head2 new_from_ical($txt)

Creates a new Journal object from a string of valid iCalendar text. 

=cut


#=====INTERNAL FUNCTIONS=====================================================

#----------------------------------------------------------------------------
# validate ($class, $ref_to_args_hash)
# make sure that this object has the bare minimum requirements
# specified by the RFC.
#----------------------------------------------------------------------------
sub _validate {
	my ($class, $args) = @_;
	
	# fill these in later, for example
	# return undef unless $args{attendee};

	# make sure that ETJ has validated these args too. 
	return undef unless $class->SUPER::validate($args);
	
	return 1;
}


sub _create {
   	my ($class, %args) = @_;

	# this sucks, because now we don't use the validity checks in
	# ETJ::new
	my $self = $class->SUPER::_create ('VJOURNAL', %args);
	bless $self, $class;

	# TODO: modify the map to include map values that are specific to Journals, 
	# if any.
   	return $self;
}

1;

__END__

=pod
=head1 SEE ALSO

Net::ICal::Time; Net::ICal::Recurrence; Net::ICal::Attendee. If you
want to know how this works, read this and the source for Net::ICal::ETJ.
