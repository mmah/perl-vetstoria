#!/usr/bin/perl -w

use strict;
use lib '../lib';
use Vetstoria;

my $vetstoria = Vetstoria->new();
my $url;
my($hosp, $client, $patient) = ('', '', '');

print "Encoding \"HHHHHHH\", \"CCCCCCCC\", \"PPPPPPP\" yields:\n";
$url = $vetstoria->CreateURL("HHHHHHH", "CCCCCCCC", "PPPPPPP");
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "$url\n\n";

print "Encoding \"577bbe97a7115\", \"4051\", \"\" yields:\n";
$url = $vetstoria->CreateURL("577bbe97a7115", "4051", "");
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "$url\n\n";

print "Encoding \"577bbe97a7115\", \"22226\", [ \"48060:2062209\", \"48059:2122717\" ] yields:\n";
$url = $vetstoria->CreateURL("577bbe97a7115", "22226", [ "48060:2062209", "48059:2122717" ]);
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "$url\n\n";

print "Encoding \"577bbe97a7115\", \"898\", [ \"38274:2122717\" ] yields:\n";
$url = $vetstoria->CreateURL("577bbe97a7115", "898", [ "38274:2122717" ]);
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "$url\n\n";

print "Encoding \"577bbe97a7115\", \"9007\", [ \"23500\" ] yields:\n";
$url = $vetstoria->CreateURL("577bbe97a7115", "9007", [ "23500" ]);
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "$url\n\n";

print "Encoding \"577bbe97a7115\", \"4051\", [ ] yields:\n";
$url = $vetstoria->CreateURL("577bbe97a7115", "4051", [  ]);
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "$url\n\n";
   
