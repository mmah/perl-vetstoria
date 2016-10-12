#!/usr/bin/perl -w

use strict;
use lib '../lib';
use Vetstoria;

my $vetstoria = Vetstoria->new();
my $url;
my($hosp, $client, $patient) = ('', '', '');

open(INFILE, "<TestURLs.txt") or die "Unable up open TestURLs.txt";
open(OUTFILE, ">DecodedURLs.txt") or die "Unable to create DecodedURLs.txt";

while (my $url = <INFILE>) {
   chomp $url;
   ($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
   print OUTFILE "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
   print OUTFILE "$url\n\n";
}

close (INFILE);  
close (OUTFILE ); 
