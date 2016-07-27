#!/usr/bin/perl -w

use strict;
use lib '../lib';
use Vetstoria;

my $vetstoria = Vetstoria->new();

my @TestURLs = ();
#push @TestURLs, ( $vetstoria->CreateURL("HHHHHHH", "CCCCCCCC", "PPPPPPP"));
push @TestURLs, ( $vetstoria->CreateURL("577bbe97a7115", "4051", ""));
push @TestURLs, ( $vetstoria->CreateURL("577bbe97a7115", "898", [ "18844", "38274" ]));
push @TestURLs, ( $vetstoria->CreateURL("577bbe97a7115", "9007", [ "23500" ]));
push @TestURLs, ( $vetstoria->CreateURL("577bbe97a7115", "4051", [  ]));

foreach my $url (@TestURLs) {
   my($hosp, $client, $patient) = $vetstoria->DecodeURL($url);

   print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
   print "$url\n\n";
}
