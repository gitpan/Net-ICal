#!/usr/bin/perl
# -*- Mode: perl -*-
#======================================================================
# FILE: Parameter.pm
# CREATOR: eric 16 August 1999
#
# DESCRIPTION:
#   
#
#  $Id: Parameter.pm,v 1.3 2000/03/20 07:40:42 eric Exp $
#  $Locker:  $
#
# (C) COPYRIGHT 1999 Eric Busboom
# http://www.softwarestudio.org 
#
# The contents of this file are subject to the Mozilla Public License
# Version 1.0 (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# http://www.mozilla.org/MPL/
# 
# Software distributed under the License is distributed on an "AS IS"
# basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
# the License for the specific language governing rights and
# limitations under the License.
# 
# The Original Code is Parameter.pm. The Initial Developer of the Original
# Code is Eric Busboom
#
#======================================================================

package Net::ICal::Parameter;

sub new {
}

sub clone {
}

sub type {
  my $self = shift;
  my $impl = $self->_impl();

  return Net::ICal::icalcomponent_isa($impl);
}


sub is_valid {
}

sub as_ical_string{
  my $self = shift;

  return Net::ICal::icalparameter_as_ical_string($self->_impl());

}

sub _impl {
  my $self = shift;
  return $self->[0];
}

sub DESTROY {
}


# Everything below this line is machine generated. Do not edit. 

# ALTREP 

package Net::ICal::Parameter::Altrep;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_ALTREP_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_ALTREP_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# CN 

package Net::ICal::Parameter::Cn;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_CN_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_CN_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# CUTYPE 

package Net::ICal::Parameter::Cutype;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_CUTYPE_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_CUTYPE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# DELEGATED-FROM 

package Net::ICal::Parameter::DelegatedFrom;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_DELEGATEDFROM_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_DELEGATEDFROM_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# DELEGATED-TO 

package Net::ICal::Parameter::DelegatedTo;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_DELEGATEDTO_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_DELEGATEDTO_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# DIR 

package Net::ICal::Parameter::Dir;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_DIR_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_DIR_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# ENCODING 

package Net::ICal::Parameter::Encoding;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_ENCODING_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_ENCODING_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# FBTYPE 

package Net::ICal::Parameter::Fbtype;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_FBTYPE_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_FBTYPE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# FMTTYPE 

package Net::ICal::Parameter::Fmttype;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_FMTTYPE_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_FMTTYPE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# LANGUAGE 

package Net::ICal::Parameter::Language;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_LANGUAGE_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_LANGUAGE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# MEMBER 

package Net::ICal::Parameter::Member;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_MEMBER_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_MEMBER_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# PARTSTAT 

package Net::ICal::Parameter::Partstat;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_PARTSTAT_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_PARTSTAT_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# RANGE 

package Net::ICal::Parameter::Range;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_RANGE_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_RANGE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# RELATED 

package Net::ICal::Parameter::Related;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_RELATED_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_RELATED_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# RELTYPE 

package Net::ICal::Parameter::Reltype;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_RELTYPE_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_RELTYPE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# ROLE 

package Net::ICal::Parameter::Role;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_ROLE_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_ROLE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# RSVP 

package Net::ICal::Parameter::Rsvp;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_RSVP_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_RSVP_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# SENT-BY 

package Net::ICal::Parameter::SentBy;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_SENTBY_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_SENTBY_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# TZID 

package Net::ICal::Parameter::Tzid;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_TZID_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_TZID_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# VALUE 

package Net::ICal::Parameter::Value;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_VALUE_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_VALUE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# X 

package Net::ICal::Parameter::X;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_X_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_X_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# X-LIC-ERRORTYPE 

package Net::ICal::Parameter::XLicErrortype;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_XLICERRORTYPE_PARAMETER,$value);
   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_XLICERRORTYPE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}


# X-LIC-COMPARETYPE 

package Net::ICal::Parameter::XLicComparetype;
@ISA=qw(Net::ICal::Parameter);

sub new
{
   my $self = [];
   my $package = shift;
   my $value = shift;

   bless $self, $package;

   my $p;

   if ($value) {
      $p = Net::ICal::icalparameter_new_from_string($Net::ICal::ICAL_XLICCOMPARETYPE_PARAMETER,$value);

   } else {
      $p = Net::ICal::icalparameter_new($Net::ICal::ICAL_XLICCOMPARETYPE_PARAMETER);
   }

   $self->[0] = $p;

   return $self;
}

sub get
{
   my $self = shift;
   my $impl = $self->_impl();

   return Net::ICal::icalparameter_as_ical_string($impl);

}

sub set
{
   # This is hard to implement, so I've punted for now. 
   die "Set is not implemented";
}

