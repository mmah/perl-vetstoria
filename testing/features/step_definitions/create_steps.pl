#!/usr/local/bin/perl
use strict;
use warnings;
use Test::More;
use Method::Signatures;
use lib '../lib';
use Vetstoria;

my $vetstoria = undef;

Given qr/a usable (\S+) module/, sub {
   $vetstoria = Vetstoria->new();
   use_ok( $1 );
};

When qr/I encode a URL with "([^"]*)" and "([^"]*)"/, func($c) {
   my $client = $1;
   my $patient_list = $2;
   $patient_list =~ s/"//g;
   my @patients = split(/,/, $patient_list);
   my $url = $vetstoria->CreateURL("577bbe97a7115", $client, [ @patients ]);
   $c->stash->{scenario}->{encoded_url} = $url;
   #print "$url\n";
   ok $url, "got url";
};

Then qr/I should translate that URL back to "([^"]*)"/, func($c) {
   my $expected_list = $1;
   $expected_list =~ s/"//g;
   $expected_list =~ s/ //g;
   #print "expected_list = $expected_list\n";
   my $encoded_url = $c->stash->{scenario}->{encoded_url};
   unless ($expected_list =~ /^(.*?),(.*)$/) {
      fail "The expected result is in the wrong format ($expected_list)";
   }
   my $needed_client = $1;
   my $needed_patient_list = $2;
   my ($hosp, $client, $patient_list) = $vetstoria->DecodeURL($encoded_url);
   if ($client ne $needed_client) {
      fail "client incorrect, received $client";
   }
   #print "patient_list = $patient_list\n";
   $patient_list =~ s/ //g;
   my $new_patient_list = '';
   foreach my $patient (split(/,/, $patient_list)) { 
      #print "patient = $patient\n";
      unless ($patient =~ /\{\"p_id\":\"([^"]*)\"\}/) {
         fail "unexpected patient field '$patient'\n";
      }
      $new_patient_list .= "$1,";
   }
   $new_patient_list = substr($new_patient_list, 0, length($new_patient_list)-1);
   #print "new_patient_list = $new_patient_list\n";
   #print "needed_patient_list = $needed_patient_list";
   ok $new_patient_list eq $needed_patient_list, "Patients match";
};
