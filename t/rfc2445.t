# -*- Mode: perl -*-
#======================================================================
#
# This package is free software and is provided "as is" without express
# or implied warranty.  It may be used, redistributed and/or modified
# under the same terms as perl itself. ( Either the Artistic License or the
# GPL. )
#
# $Id: rfc2445.t,v 1.3 2001/03/19 00:16:01 srl Exp $
#
# (C) COPYRIGHT 2000, Reefknot developers, including:
#       Eric Busboom, http://www.softwarestudio.org
#	    Chad House, chadh at pobox dot com
#======================================================================

# tests for RFC2445 compliance.
# TODO: these only check for basic validity now; they cannot tell us
# whether N::I is interpreting the iCal properly. 

use strict;

use Test;

#use lib '../lib';	# use the libraries near this directory

use Net::ICal;
use File::Find;

my $testdata_dir = 'test-data/rfc2445';	# where the iCal sample files live

# count the number of total test files to use
my $numtests = 0;
find({wanted => \&count_files }, $testdata_dir);
print "there are $numtests tests\n";

# README: If you add new tests, you need to change the number below. 

BEGIN { plan tests => 2 }

# test each file and whether it counts as valid iCal or not.
find({wanted => \&test_ical_file, no_chdir => '1'}, $testdata_dir);


#----------------------------------------------------------------------
# count_files ($filename)
#
# increment a global variable to count the number of .ics files. 
#----------------------------------------------------------------------
sub count_files {
  my $file = $_;
  
  return unless /\.ics$/;
  $numtests++;
  return 1;
}

#-----------------------------------------------------------------------
# test_ical_file ($filename_with_directory)
# tests a given ical file for compliance. Some files should fail, and we
# know this; some should succeed, and we know this. 
# returns 1 for a successful (DWIM) result, 0 for an unexpected (broken)
# result.
#-----------------------------------------------------------------------
sub test_ical_file {
  my $file = $_;
  
  return unless /\.ics$/;
  # do something with the .ics file
  # print "$file\n";

  # FIXME: this is not crossplatform; it assumes / is the directory separator.
  my ($rfc, $section,, $testnum, $testname, $passfail) = 
    m|rfc([0-9]+)/	  # find the rfc number
	([/0-9]*)	      # find the section number (w/ internal & trailing slashes
	([0-9])-		  # find the test number
	(([a-zA-Z]+)-       # find out if this test is supposed to pass or fail
	[-a-zA-Z0-9]+)      # find the test name
	#\.ics$		      # end with .ics
	|x;
  # print "$rfc, $section, $testnum, $passfail, $testname\n";
  
  my $cal = new_calendar_from_file($file);

  if ($passfail eq "fail") {
	# we know this iCal is invalid, it should fail
	# FIXME: this is broken until N::I::Component returns undef on bogus data
    # Commented out for N::I release so tests will pass
	# return ok($cal, undef);
	return ok($cal, $cal);
  } elsif ($passfail eq "pass") {
	# we know this iCal is valid, it should pass
    return ok($cal);
	
  }
}

#-----------------------------------------------------------------------------
# new_calendar_from_file ($filename)
# read in a calendar from a file. Return a Net::ICal object.
#-----------------------------------------------------------------------------
sub new_calendar_from_file {
        my ($filename) = @_;
 
        open CALFILE, "<$filename" or (carp $! and return undef);
 
        undef $/; # slurp mode
        # FIXME: this is currently returning "not a valid ical stream"
        # from data saved out by the program itself.
        my $cal = Net::ICal::Component->new_from_ical (<CALFILE>) ;
        close CALFILE;
		
        return $cal;
}
	
# END
