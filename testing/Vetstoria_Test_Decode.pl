#!/usr/bin/perl -w

use strict;
use lib '../lib';
use Vetstoria;

my $vetstoria = Vetstoria->new();
my $url;
my($hosp, $client, $patient) = ('', '', '');

$url = "https://booking-qa.vetstoria.com/577bbe97a7115/UmFuZG9tSVb1KH7YpCDsVnXtKli9CPm7fyLvgK6zW7C_j7N94YvfH4OKKV0boA7W1CCL9FyMTFx7b7_WZk2E7fzKZCB3JiT7iav5y5gumXM#/";
$url = "https://booking-qa.vetstoria.com/577bbe97a7115/UmFuZG9tSVZ0DbOjDpR8H4GxW9HMH7EQI1AWFfMZlOE6hAgLKpE8i1cJdwL4XKAWO7I1aYA1HYDSQVaGzhpjzjU8TTfAK58unzLh5j_3NV5YQqcCcpuEOhs2-7SrHukvZdn_fFaP4NTld36NmBbXAJ0ZVeQ5zKrAT3TDkEapRRhnkOi0sS1pE_Yu9nt0BaM4XpJjuR40k82fEXIkT9rP-sJylfoVa0rIfNZvzbXUsRtIM339XdMw46cVxpb9K5xOfj0HO30dTBauhy8XUCJ9v9Xdl4BOWlr8#/";
($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
print "$url\n\n";


   
