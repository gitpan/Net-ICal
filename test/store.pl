#!/usr/bin/perl
#
# Store.pl. read the components out of a cluster and put them into a Store

use lib "../blib/lib";
use lib "../blib/arch";
use lib "../";

use Net::ICal;

use Net::ICal::Cluster;
use Net::ICal::Store;

package main; 

# 'store' must be a directory. 
die "usage: store.pl cluster store\n" if !$ARGV[1];

$cluster = new Net::ICal::Cluster($ARGV[0]);
$store = new Net::ICal::Store($ARGV[1]);

die "Failed to create cluster for $ARGV[0]\n" if !$cluster;
die "Failed to create store for $ARGV[1]\n" if !$store;

$count = 0;

for ($c = $cluster->first();$c != undef;$c = $cluster->next()){

  $count++;

  my $clone = $c->clone();

  print $clone->as_ical_string();

  $store->add($clone);
  
}
	
