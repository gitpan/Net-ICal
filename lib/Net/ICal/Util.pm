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
# $Id: Util.pm,v 1.3 2001/07/26 05:51:05 srl Exp $
#
# (C) COPYRIGHT 2000-2001, Reefknot developers.
#
# See the AUTHORS file included in the distribution for a full list.
#======================================================================

=head1 NAME

Net::ICal::Util -- Utility functions for Net::ICal modules

=cut

package Net::ICal::Util;
use strict;

use base qw(Exporter);

use Net::Domain qw(hostfqdn);
use Date::ICal;

our %EXPORT_TAGS = (
    all => [qw(
	create_uuid
	add_validation_error
    )],
);

our @EXPORT = ();
our @EXPORT_OK = qw(
    create_uuid
    add_validation_error
);

=head1 DESCRIPTION

General utility functions for Net::ICal and friends

=head1 FUNCTIONS

=head2 create_uuid

Generate a globally unique ID.

=cut

my $count = 0;
sub create_uuid {
    my ($time) = @_;

    unless (defined $time) {
	#what we really want, but Date::ICal can't handle that yet
	#$time = Date::ICal->new (epoch => time, timezone => 'UTC');
	$time = Date::ICal->new (epoch => time);
    }

    #quick internals hack into Date::ICal to force UTC time instead
    $time->{timezone} = "UTC"; 

    # using Net::Domain to get a fqdn
    my $host = &hostfqdn;	
    chomp $host;

    return $time->ical # time with second precision
	 . "-$$-"      # plus process id
	 . $count++    # plus counter
	 . "\@$host";  # plus fqdn should be sufficiently unique
}

=head2 add_validation_error ($object, $string)

Add a validation error containing $string to the errlog list of 
$object

=cut

sub add_validation_error {
    my ($obj, $str) = @_;
    my $err;

    my $domain = caller;
    $domain =~ s/(.*)::\w+/$1/;
    $err = "[$domain] " . $obj->type;
    #if (UNIVERSAL::can ($obj, 'uid')) {
    #if ($obj->uid) {
#	$err .= " (" . $obj->uid . ")";
#    }
    $err .= ": $str";
    push (@{$obj->errlog}, $err);
}

1;

=head1 SEE ALSO

More documentation pointers can be found in L<Net::ICal>.

=cut
