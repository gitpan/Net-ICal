#!/usr/bin/perl -w
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. ) 
#
# (C) COPYRIGHT 2000-2001, Reefknot developers.
#
# See the AUTHORS file included in the distribution for a full list. 
#======================================================================

=pod

=head1 NAME

Net::ICal::Time -- represent a time and date

=head1 SYNOPSIS

  $t = new Net::ICal::Time("19970101T120000Z");
  $t = new Net::ICal::Time("19970101T120000","America/Los_Angeles");
  $t = new Net::ICal::Time(time(),"America/Los_Angeles");

  $t2 = $t->add(Net::Ical::Duration("1D"));

  $duration = $t->subtract(Net::ICal::Time("19970101T110000Z"))

  # Add 5 minutes
  $t->min($t->min()+5);

  # Add 5 minutes
  $t->sec($t->sec()+300);

  # Compare
  if($t->compare($t2) > 0) {}

=head1 DESCRIPTION

I<Time> represents a time, but can also hold the time zone for the
time and indicate if the time should be treated as a date. The time
can be constructed from a variey of formats.

=head1 METHODS

=cut

package Net::ICal::Time;
use Net::ICal::Duration;
use Time::Local;
use POSIX;
use Carp qw(confess cluck);
use strict;
use UNIVERSAL qw(isa);


=pod

=head2 new

Creates a new time object given one of:

=over 4

=item * ISO format string

=item * Some other format string, maybe whatever a Date module understands

=item * Integer representing seconds past the POSIX epoch

=back

The optional second argument is the timezone in Olsen place name format, 
which looks like "America/Los_Angeles"; it can be used to get the standard 
offset from UTC, the dates the location goes to and from Daylight Savings 
Time, and the magnitude of the Daylight Savings time offset. 

=cut

sub new{
  my $package = shift;

  if($#_ >2){
    return Net::ICal::Time::new_from_broken($package,@_);
  } else {
    return Net::ICal::Time::new_from_string($package,$_[0],$_[1]);
  }
}


# Make a new Time object, given an integer like that returned by time().
sub new_from_int {
  my $package = shift;
  my $int = shift;

  return new_from_broken($package, gmtime($int)); 
}


# Make a new Time object, given an array like that returned by gmtime().
sub new_from_broken{
  my $package = shift;
  my $timezone = pop;
  my $self = {};

  ($self->{SECOND}, $self->{MINUTE},$self->{HOUR},$self->{DAY},
   $self->{MONTH},$self->{YEAR}) = @_;

  $self->{TIMEZONE} = $timezone;
  if (defined $timezone and $timezone eq 'UTC') {
    $self->{ISUTC} = 1;
  }

  return bless($self,$package);

}

# Make a new Time object, given an ISO format string. 
sub new_from_string{

  my $package = shift;
  my $arg = shift;
  my $timezone = shift;
  my $self = {};

  if($arg =~ /(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)(\w?)/ ){

    $self->{SECOND} = $6;
    $self->{MINUTE} = $5;
    $self->{HOUR} = $4;
    $self->{DAY} = $3;
    $self->{MONTH} = $2-1;
    $self->{YEAR} = $1-1900;

    $self->{ISUTC} = ($7 eq 'Z');
    $self->{ISDATE} = 0;
    
  } elsif($arg =~ /(\d\d\d\d)(\d\d)(\d\d)/){

    $self->{SECOND} = 0;
    $self->{MINUTE} = 0;
    $self->{HOUR} = 0;
    $self->{DAY} = $3;
    $self->{MONTH} = $2-1;
    $self->{YEAR} = $1-1900;

    if (defined $timezone and $timezone eq 'UTC') {
      $self->{ISUTC} = 1;
    } else {
      $self->{ISUTC} = 0;
    }
    $self->{ISDATE} = 1;

  } else {
    cluck "Invalid argument Net::ICal::Time::new_from_string\n";
    return undef;
  }

  $self->{TIMEZONE} = $timezone;
	  
  return bless ($self,$package);

}


=pod

=head2 clone()

Create a new copy of this time. 

=cut

# clone a Time object. 
sub clone {
  my $self = shift;

  return bless( {%$self},ref($self));

}



=pod

=head2 is_valid()

TBD

=cut

# XXX This needs to be defined.
sub is_valid{}


=pod

=head2 is_date([true|false])

Accessor to the is_date flag. If true, the flag indicates that the
hour, minute and second fields are set to zero and not used in
comparisons.

=cut

sub is_date {
  my $self = shift;
  if(@_){
    $self->{ISDATE} = !(!($_[0])); # Convert to true or false
  } else {
    return  $self->{ISDATE};
  }
}

=pod

=head2 zone

Accessor to the timezone. Takes & Returns an Olsen place name
("America/Los_Angeles", etc. ) , an Abbreviation, 'UTC', or 'float' if
no zone was specified.

=cut

# XXX This needs to be defined. 
sub zone {}


=pod

=head2 normalize()

Adjust any out-of range values so that they are in-range. For
instance, 12:65:00 would become 13:05:00.

=cut

sub normalize{
  my $self = shift;
  
  my $time_t = POSIX::mktime($self->{SECOND}, $self->{MINUTE},$self->{HOUR},
			     $self->{DAY},$self->{MONTH},$self->{YEAR});
  
 ($self->{SECOND}, $self->{MINUTE},$self->{HOUR},$self->{DAY},
   $self->{MONTH},$self->{YEAR}) = localtime($time_t);

  return;
}

# Time Value Accessors. I am not convinced that these should be
# here. They seem so Non-OO. 

=pod

=head2 hour([$hour])

Accessor to the hour.  Out of range values are normalized. 

=cut
sub hour{
  my $self = shift;
  $self->{HOUR} = $_[0] if @_;
  $self->normalize() if @_;
  return $self->{HOUR};
}

=pod
=head2 minute([$min])

Accessor to the minute. Out of range values are normalized.

=cut
sub minute {
  my $self = shift;
  $self->{MINUTE} = $_[0] if @_;
  $self->normalize() if @_;
  return $self->{MINUTE};
}

=pod
=head2 second([$dsecond])

Accessor to the second. Out of range values are normalized. For
instance, setting the second to -1 will decrement the minute and set
the second to 59, while setting the second to 3600 will increment the
hour.

=cut
sub second {
  my $self = shift;
  $self->{SECOND} = $_[0] if @_;
  $self->normalize() if @_;
  return $self->{SECOND};
}

=pod

=head2 year([$year])

Accessor to the year. Out of range values are normalized. 

=cut
sub year {
  my $self = shift;
  $self->{YEAR} = $_[0] if @_;
  $self->normalize() if @_;
  return  $self->{YEAR};
}

=pod

=head2 month([$month])

Accessor to the month.  Out of range values are normalized. 

=cut
sub month {
  my $self = shift;
  $self->{MONTH} = $_[0] if @_;
  $self->normalize() if @_;
  return  $self->{MONTH};
}

=pod

=head2 day([$day])

Accessor to the month day.  Out of range values are normalized. 

=cut
sub day {
  my $self = shift;
  $self->{DAY} = $_[0] if @_;
  $self->normalize() if @_;
  return $self->{DAY};
}


=pod

=head2 add($duration)

Takes a I<Duration> and returns a I<Time> that is the sum of the time
and the duration. Does not modify this time.

=cut
sub add {
  my $self = shift;
  my $dur = shift;

  cluck "Net::ICal::Time::add argument 1 requires a Net::ICal::Duration" if !isa($dur,'Net::ICal::Duration');

  my $c = $self->clone();

  $c->second($dur->as_int());

  $c->normalize();

  return $c;

}

=pod

=head2 subtract($time)

Subtract out a time of type I<Time> and return a I<Duration>. Does not
modify this time.

=cut
sub subtract {
  my $self = shift;
  my $t = shift;

  cluck "Net::ICal::Time::subtract argrument 1 requires a Net::ICal::Time" if !isa($t,'Net::ICal::Time');

  my $tint1 = $self->as_int();
  my $tint2 = $t->as_int();

  return new Net::ICal::Duration($tint1 - $tint2);

}

=pod

=head2 move_to_zone($zone);

Change the time to what it would be in the named timezone. 
The zone can be an Olsen placename or "UTC".

=cut

# XXX this needs implementing. 
sub move_to_zone {
  confess "Not Implemented\n";
} 

=pod

=head2 as_ical()

Convert to an iCal format time string.

=cut
sub as_ical_value {
  my $self = shift;
  my $out;
  
  if($self->{ISDATE}){
    $out = sprintf("%04d%02d%02d",$self->{YEAR}+1900,
	    $self->{MONTH}+1,$self->{DAY});
  } else {

    $out = sprintf("%04d%02d%02dT%02d%02d%02d",$self->{YEAR}+1900,
	    $self->{MONTH}+1,$self->{DAY}, $self->{HOUR},$self->{MINUTE},
	    $self->{SECOND});

    $out .= "Z" if $self->{ISUTC};

  }

  return $out;

}

=pod

=head2 as_ical()

Convert to an iCal format property string.

=cut
sub as_ical {
  my $self = shift;
  my $out;

  my $value = $self->as_ical_value();

  if($self->{DATE}){
    $out = ";VALUE=DATE";
  }

  if ($self->{TIMEZONE}){
    $out .= ";TZID=".$self->{TIMEZONE};
  }
    
  $out .= ":".$value;
  
  return $out; 
}

=pod

=head2 as_int()

Convert the time to an integer that represents seconds past the POSIX
epoch

=cut
sub as_int {
  my $self = shift;

  return timegm($self->{SECOND},$self->{MINUTE}, $self->{HOUR},$self->{DAY},
	$self->{MONTH}, $self->{YEAR});	

}

=pod

=head2 as_localtime()

Convert to list format, as per localtime()

=cut
sub as_localtime {
  my $self = shift;

  return localtime($self->as_int());

}

=pod

=head2 as_gmtime()

Convert to list format, as per gmtime()

=cut
sub as_gmtime {
  my $self = shift;

  return gmtime($self->as_int());

}

=pod

=head2 compare($time)

Compare a time to this one and return -1 if the argument is earlier
than this one, 1 if it is later, and 0 if it is the same. The routine
does the comparision after converting the time to UTC. It converts
floating times using the system's notion of the timezone.

=cut
sub compare {
  my $self = shift;
  my $a = $self->as_int();

  my $arg = shift;

  if(!isa($arg,'Net::ICal::Time')){
    $arg = new Net::ICal::Time($arg);
  }

  my $b = $arg->as_int();

  if($a < $b){
    return -1;
  } elsif ($a > $b) {
    return 1;
  } else {
    return 0;
  }
  
}

=pod

=head2 day_of_week()

Return 0-6 representing day of week of this date. Could be replaced
with (gmtime($t->as_int()))[6]

=cut
# XXX Implement this
sub day_of_week {
  confess "Not Implemented";
}

=pod

=head2 day_of_year()

Return 1-365 representing day of year of this date. Could be replaced
with (gmtime($t->as_int()))[7]

=cut

# XXX Implement this
sub day_of_year {
  confess "Not Implemented";
}


=pod

=head2 start_of_week()

Return the day of year of the first day (Sunday) of the week that
this date is in

=cut

# XXX Implement this
sub start_of_week {
  confess "Not Implemented";
}


1; 

__END__

