#!/usr/bin/perl -w
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. ) 
#
# $Id: Alarm.pm,v 1.11 2001/03/25 00:15:08 srl Exp $
#
# (C) COPYRIGHT 2000, Reefknot developers
# 
# See the AUTHORS file included in the distribution for a full list. 
#======================================================================

=head1 NAME

Net::ICal::Alarm -- represent a VALARM

=cut

package Net::ICal::Alarm;
use strict;

use Net::ICal::Component;

BEGIN {
   @Net::ICal::Alarm::ISA = qw(Net::ICal::Component);
}

=head1 SYNOPSIS

use Net::ICal;
# simple syntax
$a = new Net::ICal::Alarm(action => 'DISPLAY',
                          trigger => "20000101T073000",
                          description => "Wake Up!");

# elaborate
$a = new Net::ICal::Alarm (action => 'EMAIL',
			   trigger => new Net::ICal::Trigger (
			   type => 'DURATION',
			   content => new Net::ICal::Duration ("-PT5M"),
		           related => 'END'),
			   attendee => [new Net::ICal::Attendee ("mailto:alice\@wonderland.com")],
			   summary => "mail subject",
			   description => "mail contents");

=head1 DESCRIPTION

This class handles reminders for Net::ICal Events and Todos. You can
get a reminder in several different ways (a sound played, a message
displayed on your screen, an email or a script/application run
for you) at a certain time, either relative to the Event or Todo
the Alarm is part of, or at a fixed date/time

=head1 CONSTRUCTOR

=head2 new (optionhash)

Create a new Alarm. The minimum options are an action, a trigger and
either an attach or a description.

The action describes what type of Alarm this is going to be. See
L<"alarm"> below for possible options. The trigger describes when
the alarm will be triggered. See L<"trigger"> below for an explanation.

=cut

sub new {
    my ($class, %args) = @_;
   
    # this implements the heart of RFC2445 4.6.6, which says what
    # elements in an Alarm are required to be used.
    # Anything that's "return undef" is requred.
    
    # action and trigger are required.
    return undef unless defined $args{'action'};
    return undef unless defined $args{'trigger'};

    # display and email alarms must have descriptions.
    if ($args{'action'} eq 'DISPLAY' or $args{'action'} eq 'EMAIL') {
	return undef unless defined $args{'description'};
    }
    if (($args{'action'} ne 'EMAIL') and (defined $args{'attendee'})) {
        return undef;
    }

    # procedure alarms must invoke an attachment.
    # TODO: Attachments? This could be (is) implemented very poorly in some
    # of MS's software. eek.
    #BUG: 404132
    if ($args{'action'} eq 'PROCEDURE') {
	return undef unless defined $args{'attach'};
    }

    #FIXME: it sucks we have to do this in every component. better
    #       try to get this into Component
    #BUG: 233771
    my $t = $args{'trigger'};
    unless (ref ($t)) {
	$args{'trigger'} = new Net::ICal::Trigger ($t);
    }

    return &_create ($class, %args);
}

#============================================================================
# create ($class, %args)
#
# sets up a map of the properties that N::I::Alarm objects share.
# See Net::ICal::Component and Class::MethodMapper if you want to know
# how this works. Takes a class name and a hash of arguments, returns a new
# Net::ICal::Alarm object. 
#============================================================================
sub _create {
  my ($class, %args) = @_;
   
=head1 METHODS

=head2 action
The action can be:

=over 4

=item * AUDIO - play an audio file. Requires an L<"attach"> property
(a soundfile).

=item * DISPLAY - pop up a note on the screen. Requires a L<"description">
containing the text of the note.

=item * EMAIL - send an email. Requires a L<"description"> containing the
email body and one or more L<"attendee">s for the email address(es).

=item * PROCEDURE - trigger a procedure described by an L<"attach">
which is the command to execute (required).

=back

=head2 trigger

The time at which to fire of the reminder. This can either be relative
to the Event/Todo (a L<Net::ICal::Duration> or at a fixed date/time
(a L<Net::ICal::Time>)

=head2 summary

If the Alarm has an EMAIL L<"action"> then the text of the summary string
will be the Subject header of the email.

=head2 description

If the Alarm has an EMAIL L<"action"> then the text of the description string
will be the body of the email. If it's a PROCEDURE, this is the argument
string to be passed to the program

=head2 attach

If the Alarm is an AUDIO alarm, this contains the sound to be played,
either as an URL or inline. If the Alarm has L<"action"> EMAIL, this
will be attached to the email. Finally, if it is a PROCEDURE Alarm,
it contains the application to be executed.

=head2 attendee

This contains one or more L<Net::ICal::Attendee> objects that describe
the email addresses of the people that need to receive this Alarm. This
is only valid for EMAIL Alarms of course.

=head2 repeat

The number of times the Alarm must be repeated. If you specify this,
you must also specify L<"duration">

=head2 duration

The time before the Alarm is repeated. This is a L<Net::ICal::Duration>
object.

=cut

   my $map = {		# RFC2445 4.6.6
      action => {
	 type => 'parameter',
	 doc => 'the action type of this alarm',
	 domain => 'enum',
	 options => [qw(AUDIO DISPLAY EMAIL PROCEDURE)],
	 value => 'EMAIL', # default
      },
      trigger => {
	 type => 'parameter',
	 doc => 'when the alarm will be triggered',
	 domain => 'ref',
	 options => 'Net::ICal::Trigger',
	 value => undef,
      },
      description => {
	 type => 'parameter',
	 doc => 'description of this alarm',
	 domain => 'param',
	 options => [qw(altrep language)],
	 value => undef,
      },
    # this might be better off as a class
      attach => {
	 type => 'parameter',
	 doc => 'an attachment',
	 domain => 'param',
	 options => [qw(encoding value fmttype)],
	 value => undef,
      },
      summary => {
	 type => 'parameter',
	 doc => 'the summary (subject) if this is an EMAIL alarm',
	 domain => 'param',
	 options => [qw(altrep language)],
	 value => undef,
      },
      attendee => {
	 type => 'parameter',
	 doc => 'the attendees(receivers of the email) for this EMAIL alarm',
	 domain => 'ref',
	 options => 'ARRAY',
	 value => undef,
      },
      duration => {
	 type => 'parameter',
	 doc => 'the delay period between alarm repetitions',
	 value => 0,
      },
      repeat => {
	 type => 'parameter',
	 doc => 'the amount of times the alarm is repeated',
	 value => 0,
      },
   };
   my $self = $class->SUPER::new ('VALARM', $map, %args);

   return $self;
}

1;
