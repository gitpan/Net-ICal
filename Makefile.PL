#!/usr/bin/perl
# -*- Mode: perl -*-

use ExtUtils::MakeMaker;

# run this on "make dist" to build the BUGS file.
sub MY::postamble {
   package MY;
   "\npredist: all\n" .
   "\tperl -w ../tools/createBUGS.pl>BUGS\n" .
   "\t\$(MAKE) manifest\n" .
   "\t\$(MAKE) tardist\n"
}

WriteMakefile(
	        'MAKEFILE'=> 'Makefile',
	        'VERSION_FROM' => 'lib/Net/ICal.pm',
	        'NAME'    => 'Net::ICal', 
            'PREREQ_PM'  => { # e.g., Module::Name => 1.1
              'Class::MethodMapper' => 1.0 
            },
            dist => {
              COMPRESS     =>'gzip',
              SUFFIX       =>'gz',
              DIST_DEFAULT =>'predist',
            },

	      );

