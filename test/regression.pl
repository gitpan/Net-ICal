#!/usr/bin/perl

use lib "../lib/";
use lib "../";

use Net::ICal;
use Time::Local;

#use Net::ICal::Store;

package main; 

test Net::ICal::Duration; 

test Net::ICal::Time;

test Net::ICal::Period;

test Net::ICal::Component;

test Net::ICal::Attendee;
