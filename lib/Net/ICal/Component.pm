#!/usr/bin/perl -w
# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. ) 
#
# $Id
#
# (C) COPYRIGHT 2000, Reefknot developers, including: 
#   Eric Busboom, http://www.softwarestudio.org
# 
# See the AUTHORS file included in the distribution for a full list. 
#======================================================================


=head1 NAME

Net::ICal::Component -- the base class for ICalender components

=cut

package Net::ICal::Component;
use strict;

use Class::MethodMapper;
use UNIVERSAL qw(isa);

BEGIN {
   @Net::ICal::Component::ISA = qw(Class::MethodMapper);
}

=head1 SYNOPSIS
You never create an instance of this class directly, so we'll assume
$c is an already created component.

    # returns an ICal string for this component.
    $c->as_ical;

=head1 DESCRIPTION

This is the base class we derive specific ICal components from.
It contains a map of properties which can be set and accessed at will;
see the docs for Class::MethodMapper for more on how it works.

=head1 CONSTRUCTORS

=head2 new($name, $map, %args)

Creates a new ICal component of type C<$name>, with Class::MethodMapper
map C<$map> and arguments C<%args>. You never call this directly, but
you use the specific component's new constructor instead, which in turn
calls this.

=cut

sub _param_set {
   #TODO? allow things like $foo->description ("blah blah", altrep => 'foo');
   my ($self, $key, $val) = @_;
   my ($class) = $self =~ /^(.*?)=/g;

   my @params = @{$self->get_meta ('options', $key)};
   if (ref($val) eq 'HASH') {
      foreach my $param (keys %$val) {
	 unless (grep { $_ eq lc($param) } ('content', @params)) {
	    warn "${class}->$key has no $param parameter. skipping.\n";
	    delete $val->{$param};
	 }
      }
      $self->{$key}->{value} = $val;
   } else {
      $self->{$key}->{value} = { content => $val };
   }
}

sub new {
   my ($classname, $name, $map, %args) = @_;

   # TODO: WTF is a type 'volatile' and why are we using it?
   $map->{'type'} = {
      type => 'volatile',
      doc => 'type of the component',
      value => $name
   };
#   $map->{'x-value'} = {
#      type => 'parameter',
#      doc => 'vendor-specific properties',
#      domain => 'ref',
#      options => 'HASH',
#      value => undef,
#   };
   my $self = new Class::MethodMapper;
   bless $self, $classname;
   $self->set_map (%$map);
   $self->set (%args);

   return $self;
}


# If a new ICal subclass object needs to be created, load the module
# and return a new instance of it. Otherwise, just return the value
# of the property.
sub _load_property {
   my ($class, $value, $line) = @_;

   unless ($class =~ /::/) {
      $class = "Net::ICal::" . ucfirst (lc ($class));
   }
   my $prop;
   eval "require $class";
   unless ($@) {
      if ($class->can ('new_from_ical')) {
	 return $class->new_from_ical($line);
      } else {
	 # for things like Time, which are just a value, not a Property,
	 # so they don't have new_from_ical
	 return $class->new ($value);
      }
   } else {
      return $value;
   }
}

=head2 new_from_ical
   
Creates a new Net::ICal::Component from an ical stream.
Use this to read in a new object before you do things with
it. 

=cut

sub new_from_ical {
   my ($class, $ical) = @_;

   # put the string into something for the callback function below to use
   my @lines = split (/\015?\012/, $ical);		# portability

   #FIXME: this should return undef if the ical is invalid
   return _parse_lines (\@lines);
}

sub _parse_lines {
   my ($lines) = @_;

   # validate the string we got to make sure it looks iCal-like.
   # the first line of the iCal will look like BEGIN:VALARM or something.
   # we need to know what comes after the V, because that's what
   # sort of component we'll be creating.
   my $begin = shift @$lines;
   my ($comp) = $begin =~ /^BEGIN:V(\w+)/g;
   unless ($comp) {
      warn "Not a valid ical stream\n";
      return undef;
   }

   # by now, $comp is "ALARM" or something. Here, 
   # $comp becomes the name of a kind of component, which we're
   # going to create. (N::I::Alarm is a subclass of N::I::Component.)
   $comp = "Net::ICal::" . ucfirst (lc ($comp));
   eval "require $comp";
   my $self = $comp->_create;

   # define a callback for Class::MethodMaker to call when it
   # restores the data from @lines.

   my $cb = sub {
      return undef unless @$lines;
      my $line = shift @$lines;

      # handle multiline fields; see "unfolding" in RFC2445. Make
      # all the multiline fields we've been handed into single-line fields.
      while (@$lines and $lines->[0] =~ /^ /) {
		  chomp $line;
		  $line .= substr (shift @$lines, 1);
      }

      if ($line =~ /^BEGIN:V(\w+)$/) {
	 my ($name) = $1;
	 unshift (@$lines, $line);
	 # yay. recursion
	 my $foo = _parse_lines ($lines);

	 # Calendar.pm has alarms/todos/etc methods, so add the s
	 $name = lc ($name) . "s";

	 # see if there's already an existing list
	 my $ref = $self->get ($name);
	 $ref = () unless $ref;
	 push (@$ref, $foo);
	 return ($name, $ref);
      } elsif ($line =~ /^END:(\w+)$/) {
	 return undef
      } else {
	 # parse out the iCalendar lines.
	 # FIXME: these will break if there's a : in a parameter value.
	 #        we're also not handling FOO:value1,value2
	 # BUG #133739
	 my ($key, $value) = $line =~ /^(.*?):(.*)$/g;
	 my ($class, $paramstr) = $key =~ /^(.*?)(?:;(.*)|$)/g;
	 $class = lc ($class);
	 # make sure we have a valid function name
	 $class =~ s/-/_/g;

         # If we start with iCalendar text like:
         #  TRIGGER;VALUE=DURATION;RELATED=START:PT5M
         #  DESCRIPTION:mail content.
         # $key will have 'TRIGGER;VALUE=DURATION;RELATED=START' 
         #   and 'DESCRIPTION'
         # $value 'PT5M' and 'mail content.'
         # $class 'TRIGGER' and 'DESCRIPTION'
         # and paramstr ';VALUE=DURATION;RELATED=START' and ''
	
# FIXME: what does this do, Martijn?
#	 if ($class =~ /^x-/) {
#	    return ('x-value', {$key => $value})
#  } elsif ($self->get_meta ('domain', $class) eq 'class') {
# } sacrificing to the demon Emacs

	 # avoid warnings for doing eq with undef below
	 if (not defined $self->get_meta ('domain', $class)) {
	    return ($class, $value);
	 # we either have an array of values, or a class for the
	 # property
	 } elsif ($self->get_meta ('domain', $class) eq 'ref') {
	    
	    # set up the array to refer to. It may be an array of objects
	    # or just an array of values; _load_property will do either.
	    if ($self->get_meta ('options', $class) eq 'ARRAY') {
	       # the array elements can be refs too
	       my $prop = _load_property ($class, $value, $line);
	       my $val = $self->get_meta ('value', $class);
	       if (defined $val) {
		  push (@$val, $prop);
		  return ($class, $val);
	       } else {
		  return ($class, [$prop]);
	       }
	    } elsif ($self->get_meta ('options', $class) eq 'HASH') {
		# FIXME: will we ever need hashref support here?
		die "BUG: we're not handling this\n";
	    } else {
	       # if this thing we're looking at needs to be made a
	       # Net::ICal::subclass object, load that module and call that
	       # subclass's new_from_ical method on this line of ical text.
	       my $prop = _load_property ($self->get_meta ('options', $class),
	                                  $value, $line);
	       return ($class, $prop);
	    }

      # if there are parameters for this thing, but not an actual subclass,
      # build a hash and return a reference to it. See, for example,
      # DESCRIPTION fields, which can have an ALTREP (like a URL) or a
      # LANGUAGE. We don't need a separate class for it; a hash will suffice.

	 } elsif ($self->get_meta ('domain', $class) eq 'param') {
	    my @params = $paramstr ? split (/;/, $paramstr) : ();
	    my %foo = (content => $value);

	    foreach my $keyvalue (@params) {
	       my ($pkey, $pvalue) = split (/=/, $keyvalue);
	       $foo{$pkey} = $pvalue;
	    }
	    return ($class, \%foo);
	 } else {
	    return ($class, $value);
	 }
      }
   }; # end of sub $cb

   $self->restore ($cb);
   return $self;
}

=pod

=head1 METHODS

=head2 type ([$string])

   Get or set the type of this component. You aren't supposed to ever
   set this directly. To create a component of a specific type, use
   the new method of the corresponding class.

=head2 as_ical

   Returns an ICal string that represents this component

=cut

sub as_ical {
   my ($self) = @_;

   # make the BEGIN: VALARM line, or whatever
   my $ical = "BEGIN:" . $self->type . "\015\012";

   # this is a callback that Class::MethodMapper will use
   # to generate the ical text.
   my $cb = sub {
      my ($self, $key, $value) = @_;
      $key =~ s/_/-/g;
      $key = uc ($key);

      return unless $value->{value};

      # if this object is just a reference to something, look at that object.
      if (not defined $value->{domain}) {
	 $ical .= $key . ":" . $value->{value} . "\015\012";
      } elsif ($value->{domain} eq 'ref') {
	 if ($value->{options} eq 'ARRAY') {
	    # for every line in this array, if it's a ref, call the
	    # referenced object's as_ical method; otherwise output a
	    # key:value pair.
	    foreach my $val (@{$value->{value}}) {
	       if (ref ($val)) {
		  if (isa ($val, 'Net::ICal::Property')) {
		     $ical .= $key . $val->as_ical . "\015\012";
		  } else {
		     $ical .= $val->as_ical();
		  }
	       } else {
		  $ical .= $key . ":$val\015\012";
	       }
	    }
	 } elsif ($value->{options} eq 'HASH') {
	 } else {
	    # assume it's a class, and call it's as_ical method
	    $ical .= $key . $value->{value}->as_ical . "\015\012";
	 }

     # if this is a thing without its own subclass, it's a hashref.
     # output the key value (DESCRIPTION, for example) and then
     # the hash's keys and values like ";key=value".

      } elsif ($value->{domain} eq 'param') {
	 my $xhash = $value->{value};
	 my $line = $key;
		 
	 # the 'content' key is the name of this property.
	 foreach my $xkey (keys %$xhash) {
	    next if ($xkey eq 'content');
	    $line .= ';' . uc ($xkey) . "=" . $xhash->{$xkey};
	 }
	 $line .= ":" . $xhash->{content} . "\015\012";

	 # don't display anything wider than 76 characters. wrap lines.
	 # FIXME: we need to do this in more places
	 # BUG #133739
	 while (length $line > 76) {
        $line =~ s/(.{1,76}\W)//;   # don't break lines in the middle of words
        $ical .= $1 . "\015\012 ";  # when we wrap a line, use this as a newline
	 }
	 $ical .= $line;

     # otherwise just output a key-value pair.
      } else {
	 $ical .= $key . ":" . $value->{value} . "\015\012";
      }
   };

  # call the Class::MethodMapper callback.
  $self->save ('parameter', $cb);

  # OUTPUT END:VALARM or whatever.
  $ical .= "END:" . $self->type . "\015\012";
  return $ical;
}

1;

=pod

=head1 SEE ALSO

=head2 Class::MethodMapper

    Most of the internals of this code are built on C::MM. You need to
    understand what it does first.

=cut

