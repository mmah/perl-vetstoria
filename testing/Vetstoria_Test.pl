#!/usr/bin/perl -w

use strict;
use lib '../lib';
use Vetstoria;

my $vetstoria = Vetstoria->new();

#my $url = $vetstoria->CreateURL("HHHHHHH", "CCCCCCCC", "PPPPPPP");
my $url = $vetstoria->CreateURL("577bbe97a7115", "4051", "");

print "\n$url\n\n";

my($hosp, $client, $patient) = $vetstoria->DecodeURL($url);

print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
