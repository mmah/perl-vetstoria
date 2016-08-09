#!/usr/bin/perl -w

use strict;
use lib '../lib';
use Vetstoria;

my $vetstoria = Vetstoria->new();
my $url;
my($hosp, $client, $patient) = ('', '', '');

print "Encoding \"577bbe97a7115\", \"11138\", [ \"39396:V109\" ] yields:\n";
$url = $vetstoria->CreateURL("577bbe97a7115", "11138", [ "39396:V109" ]);
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "Service is Bordetella Vaccine - Annual\n";
print "$url\n\n";

print "Encoding \"577bbe97a7115\", \"22430\", [ \"49223:C303\" ] yields:\n";
$url = $vetstoria->CreateURL("577bbe97a7115", "22226", [ "49223:C303" ]);
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "Service is Annual Wellness Exam\n";
print "$url\n\n";

print "Encoding \"577bbe97a7115\", \"21637\", [ \"46987:V230\" ] yields:\n";
$url = $vetstoria->CreateURL("577bbe97a7115", "21637", [ "46987:V230" ]);
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "Service is Distemper Parvo Vaccine & Exam\n";
print "$url\n\n";

