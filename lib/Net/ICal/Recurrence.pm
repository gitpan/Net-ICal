#!/usr/bin/perl -w
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without
# express or implied warranty.  It may be used, redistributed and/or
# modified under the same terms as perl itself. ( Either the Artistic
# License or the GPL. )
#
#
#======================================================================

package Net::ICal::Recurrence;

use strict; 
use warnings;
use Carp;
use vars qw(@ISA);
@ISA = qw(Net::ICal::Property);

=head1 NAME

Net::ICal::Recurrence -- Represent a single recurrence rule

=head1 SYNOPSIS

  use Net::ICal::Recurrence;
  $rrule = new Net::ICal::Recurrence([ OPTION_PAIRS ]) ;

=head1 DESCRIPTION

I<Recurrence> holds a single recurrence property, ala section 4.3.10 of
RFC 2445.

=over 4

=head2 CONSTRUCTOR

=item new([ OPTIONS_PAIRS ])

Create a new recurrence rule.  Values for any of the below settings may
be specified at intialization time.

=cut


my $enum_freq      = [ qw(SECONDLY MINUTELY HOURLY DAILY),
                       qw(WEEKLY MONTHLY YEARLY) ];
my $enum_wday      = [ qw(MO TU WE TH FR SA SU) ];
my $is_weekdaynum  = qr[^(?:(?:-|\+)?\d+)?(?:SU|MO|TU|WE|TH|FR|SA)$]i;

# Simple ranges (sets with end value that doesn't change)
my $is_second      = [0, 59];
my $is_minute      = [0, 59];
my $is_hour        = [0, 23];
my $is_monthnum    = [1, 12];

# Ranges with variable upper boundaries (negative offsets supported)
my $is_ordyrday    = [1, 366];
my $is_ordmoday    = [1,  31];
my $is_ordwk       = [1,  53];

=head2 METHODS

All of the methods that set multi-valued attributes (e.g., I<bysecond>)
accept either a single value or a reference to an array.

=item freq (FREQ)

Specify the frequency of the recurrence.  Allowable values are:

  SECONDLY MINUTELY HOURLY DAILY WEEKLY MONTHLY YEARLY

=cut

=item count(N)

Specify that the recurrence rule occurs for N recurrences, at most.
May not be used in conjunction with I<until>.

=cut

=item until(ICAL_TIME)

Specify that the recurrence rule occurs until ICAL_TIME at the latest.
ICAL_TIME is a Net::ICal::Time object.  May not be used in conjunction
with I<count>.

=cut

=item interval(N)

Specify how often the recurrence rule repeats.  Defaults to '1'.

=cut

=item bysecond([ SECOND , ... ])

Specify the valid of seconds within a minute.  SECONDs range from 0 to 59.
Use an arrayref to specify more than one value.

=cut

=item byminute([ MINUTE , ... ])

Specify the valid of minutes within an hour.  MINUTEs range from 0 to 59.
Use an arrayref to specify more than one value.

=cut

=item byhour([ HOUR , ... ])

Specify the valid of hours within a day.  HOURs range from 0 to 23.
Use an arrayref to specify more than one value.

=cut

=item byday([ WDAY , ... ])

Specify the valid weekdays.  Weekdays must be one of

  MO TU WE TH FR SA SU

and may be preceded with an ordinal week number.  If the recurrence
frequency is MONTHLY, the ordinal specifies the valid week within the
month.  If the recurrence frequency is YEARLY, the ordinal specify the
valid week within the year.  A negative ordinal specifys an offset from
the end of the month or year.

=cut

=item bymonthday([ MONTHDAY, ... ])

Specify the valid days within the month.  A negative number specifies an
offset from the end of the month.

=cut

=item byyearday([ YEARDAY, ... ])

Specify the valid day(s) within the year (i.e., 1 is January 1st).
A negative number specifies an offset from the end of the year.

=cut

=item byweekno([ WEEKNO, ... ])

Specify the valid week(s) within the year.  A negative number specifies
an offset from the end of the year.

=cut

=item bymonth([ MONTH, ... ])

Specify the valid months within the year.

=cut

=item bysetpos([ N, ... ])

Specify the valid recurrences for the recurrence rule.  Use this when
you need something more complex than INTERVAL.  N may be negative,
and would specify an occurrence before the start time of the event.

=cut

=item wkst(WEEKDAY)

Specify the starting day of the week as applicable to week calculations.
The default is MO.  The allowable options are the same weekday codes as
for I<byday>.

=cut

my $map = {

  # Dummy stub for Property.pm
  content => { },

  # "FREQ"=freq
  # freq       = "SECONDLY" / "MINUTELY" / "HOURLY" / "DAILY"
  #            / "WEEKLY" / "MONTHLY" / "YEARLY"
  freq => {	type    => 'volatile',
		doc     => 'Recurrence frequency',
		domain  => 'enum',
		options => $enum_freq,
  },

  # ( ";" "COUNT" "=" 1*DIGIT )
  count => {		type    => 'volatile',
			doc     => 'End of recurrence range',
			domain  => 'positive_int',
  },

  # ( ";" "UNTIL" "=" enddate )
  until => {		type    => 'volatile',
			doc     => 'End of recurrence range',
			domain  => 'ref',
			options => 'Net::ICal::Time',
  },
  # ( ";" "INTERVAL" "=" 1*DIGIT )
  interval => { type    => 'volatile',
		doc     => 'Event occurs every Nth instance',
		domain  => 'positive_int',
		value	=> 1,
  },

  # ( ";" "BYSECOND" "=" byseclist )        /
  # byseclist  = seconds / ( seconds *("," seconds) )
  # seconds    = 1DIGIT / 2DIGIT       ;0 to 59
  bysecond => { type    => 'volatile',
		doc     => 'Valid seconds within each minute',
		domain  => 'multi_fixed_range',
		options	=> $is_second,
  },

  # ( ";" "BYMINUTE" "=" byminlist )        /
  # byminlist  = minutes / ( minutes *("," minutes) )
  # minutes    = 1DIGIT / 2DIGIT       ;0 to 59
  byminute => { type    => 'volatile',
		doc     => 'Valid minutes within each hour',
		domain  => 'multi_fixed_range',
		options	=> $is_minute,
  },

  # ( ";" "BYHOUR" "=" byhrlist )           /
  # byhrlist   = hour / ( hour *("," hour) )
  # hour       = 1DIGIT / 2DIGIT       ;0 to 23
  byhour => {	type    => 'volatile',
		doc     => 'Valid hours within each day',
		domain  => 'multi_fixed_range',
		options	=> $is_hour,
  },

  # ( ";" "BYDAY" "=" bywdaylist )          /
  # bywdaylist = weekdaynum / ( weekdaynum *("," weekdaynum) )
  # weekdaynum = [([plus] ordwk / minus ordwk)] weekday
  # plus       = "+"
  # minus      = "-"
  # ordwk      = 1DIGIT / 2DIGIT       ;1 to 53
  byday => {	type    => 'volatile',
		doc     => 'Valid weekdsays within week',
		domain  => 'multi_match',
		options => $is_weekdaynum,
  },

  # ( ";" "BYMONTHDAY" "=" bymodaylist )    /
  # bymodaylist = monthdaynum / ( monthdaynum *("," monthdaynum) )
  # monthdaynum = ([plus] ordmoday) / (minus ordmoday)
  # ordmoday   = 1DIGIT / 2DIGIT       ;1 to 31
  bymonthday => {	type    => 'volatile',
			doc     => 'Valid days within week',
			domain  => 'multi_ordinal_range',
			options => $is_ordmoday,
  },

  # ( ";" "BYYEARDAY" "=" byyrdaylist )     /
  # byyrdaylist = yeardaynum / ( yeardaynum *("," yeardaynum) )
  # yeardaynum = ([plus] ordyrday) / (minus ordyrday)
  # plus       = "+"
  # minus      = "-"
  # ordyrday   = 1DIGIT / 2DIGIT / 3DIGIT      ;1 to 366
  byyearday => {	type    => 'volatile',
			doc     => 'Valid days within year',
			domain	=> 'multi_ordinal_range',
			options	=> $is_ordyrday,
  },

  # ( ";" "BYWEEKNO" "=" bywknolist )       /
  # bywknolist = weeknum / ( weeknum *("," weeknum) )
  # weeknum    = ([plus] ordwk) / (minus ordwk)
  # plus       = "+"
  # minus      = "-"
  # ordwk      = 1DIGIT / 2DIGIT       ;1 to 53
  byweekno => {		type    => 'volatile',
			doc     => 'Valid weeks within year',
			domain	=> 'multi_ordinal_range',
			options	=> $is_ordwk,
  },

  # ( ";" "BYMONTH" "=" bymolist )          /
  # bymolist   = monthnum / ( monthnum *("," monthnum) )
  # monthnum   = 1DIGIT / 2DIGIT       ;1 to 12
  bymonth => {		type    => 'volatile',
			doc     => 'Valid months within year',
			domain  => 'multi_fixed_range',
			options	=> $is_monthnum,
  },

  # ( ";" "BYSETPOS" "=" bysplist )         /
  # bysplist   = setposday / ( setposday *("," setposday) )
  # setposday  = yeardaynum
  # yeardaynum = ([plus] ordyrday) / (minus ordyrday)
  # plus       = "+"
  # minus      = "-"
  # ordyrday   = 1DIGIT / 2DIGIT / 3DIGIT      ;1 to 366
  bysetpos => {		type    => 'volatile',
			doc     => 'Valid occurrences of recurrence rule',
			domain  => 'multi_ordinal_range',
			options => $is_ordyrday,
  },

  # ( ";" "WKST" "=" weekday )              /
  wkst => {		type    => 'volatile',
			doc     => 'First day of week',
			domain  => 'enum',
			options => $enum_wday,
			value   => 'MO',
  },

};

#
# Set a value only if it's a positive integer (ala 1*DIGIT)
#
sub _positive_int_set ($$) : method {
  my $self = shift;
  my ($key, $val) = @_;

  if (!defined($val) || ref($val) || int($val) != $val || $val < 1) {
    carp "'$val' is not a positive integer";
    return undef;
  }

  $self->{$key}->{value} = $val;
}

#
# Set a value only if it falls within a range (inclusive)
#
sub _multi_fixed_range_set ($$) : method {
  my $self = shift;
  my ($key, $vals) = @_;

  my $ar_minmax = $self->{$key}->{options} ||
    croak "Missing required 'options' for multi_fixed_range check on '$key'";

  my ($min, $max) = @$ar_minmax;

  my @vals;
  if (ref($vals) eq 'ARRAY') {
    @vals = @$vals;
  } elsif (!ref($vals)) {
    @vals = ($vals);
  } else {
    warn "value for $key is neither a scalar nor an array reference";
    return undef;
  }

  foreach my $val (@vals) {
    if (!defined($val)) {
      carp "undefined values can't be within a numeric range";
      return undef;
    }
    if ($val < $min || $val > $max) {
      carp "'$val' is outside of allowable range of $min to $max";
      return undef;
    }
  }

  $self->{$key}->{value} = \@vals;
}

#
# Set a value if all of the elements match a regular expression
#
sub _multi_match_set ($$) : method {
  my $self = shift;
  my ($key, $vals) = @_;

  my $regex = $self->{$key}->{options} ||
    croak "Missing required 'options' for multi_match check on '$key'";

  my @vals;
  if (ref($vals) eq 'ARRAY') {
    @vals = @$vals;
  } elsif (!ref($vals)) {
    @vals = ($vals);
  } else {
    warn "value for $key is neither a scalar nor an array reference";
    return undef;
  }

  foreach my $val (@vals) {
    if (!defined($val)) {
      carp "undefined values not permitted";
      return undef;
    }
    if ($val !~ $regex) {
      carp "'$val' is not an allowable value";
      return undef;
    }
  }

  $self->{$key}->{value} = \@vals;
}

#
# Set a value if all of the elements are within a range, regardless of sign
#
sub _multi_ordinal_range_set ($$) : method {
  my $self = shift;
  my ($key, $vals) = @_;

  my $ar_minmax = $self->{$key}->{options} ||
    croak "Missing required 'options' for multi_ordinal_range check on '$key'";

  my ($min, $max) = @$ar_minmax;

  my @vals;
  if (ref($vals) eq 'ARRAY') {
    @vals = @$vals;
  } elsif (!ref($vals)) {
    @vals = ($vals);
  } else {
    warn "value for $key is neither a scalar nor an array reference";
    return undef;
  }

  foreach my $val (@vals) {
    if (!defined($val)) {
      carp "undefined values can't be within a numeric range";
      return undef;
    }
    if (abs($val) < $min || abs($val) > $max) {
      carp "'$val' is outside of allowable range ".
           "of -$max to -$min and $min to $max";
      return undef;
    }
  }

  $self->{$key}->{value} = \@vals;
}

sub new ($;%) : method {
  my $class = shift;
  my @args  = @_;

  return $class->SUPER::new('RECUR', $map, @args);
}

=item as_ical_value()

Return an iCal format RRULE string

=cut

sub as_ical_value () : method {
  my $self = shift;

  my @comps;

  # FREQ is always forced to to the front of list
  foreach my $key (sort { $a eq 'freq' ? -1 : $b eq 'freq' ? 1 : ($a cmp $b) }
                        keys %$self)
  {
    next if $key eq 'name';
    my $val = $self->{$key};
    if (exists($val->{value}) && defined($val->{value})) {
      my $value = $val->{value};
      if (!ref($value)) {			# single value
	push(@comps, uc($key).'='.uc($value));
      } elsif (ref($value) eq 'ARRAY') {	# list of values
	push(@comps, uc($key).'='.uc(join(',', @$value)));
      } elsif (ref($value) =~ /::/) {		# Internal type
	push(@comps, uc($key).'='.$value->as_ical_value);
      } else {
	croak "'$key' component of recurrence has an unexpected value ($value)";
      }
    }
  }
  return ':'.join(';', @comps);
}

sub as_ical () : method { (shift)->as_ical_value() }

=back

=head1 SEE ALSO

L<Net::ICal(3)>

=cut

1;

__END__
