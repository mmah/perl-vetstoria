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

When qr/given the client and patient parameters "([^"]*)" and ((.*))/, func($c) {
   my $client = $1;
   my $patient_list = $2;
   $patient_list =~ s/"//g;
   $patient_list = substr($patient_list, 1, length($patient_list)-2);
   #print "client = $client\n";
   #print "patients = $patient_list\n";
   my @patients = split(/,/, $patient_list);
   my $url = $vetstoria->CreateURL("577bbe97a7115", $client, [ @patients ]);    
   $c->stash->{scenario}->{encoded_url} = $url;
   ok $url, "got url";
};

Then qr/the encoded url should translate back to "([^"]*)" and ((.*))/, func ($c) {
   my $needed_client = $1;
   my $needed_patient_list = $2;
   $needed_patient_list =~ s/"//g;
   $needed_patient_list = substr($needed_patient_list, 1, length($needed_patient_list)-2);
   #print "needed_client = $needed_client\n";
   #print "needed_patient_list = $needed_patient_list\n";
   my $encoded_url = $c->stash->{scenario}->{encoded_url};
   #print "$encoded_url\n";
   my ($hosp, $client, $patient_list) = $vetstoria->DecodeURL($encoded_url);
   if ($client ne $needed_client) {
      fail "client incorrect, received $client";
   }
   #print "needed patient list = '$needed_patient_list'\n";
   #print "$patient_list\n";
   $patient_list =~ s/ //g;
   #print "$patient_list\n";
   my $new_patient_list = '';
   foreach my $patient (split(/,/, $patient_list)) { 
      unless ($patient =~ /\{\"p_id\":\"([^"]*)\"\}/) {
         fail "unexpected patient field '$patient'\n";
      }
      $new_patient_list .= "$1,"; 
   }
   $new_patient_list = substr($new_patient_list, 0, length($new_patient_list)-1);
   ok $needed_patient_list eq $new_patient_list, "client and patient fields match";
};
