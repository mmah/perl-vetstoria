#!/usr/local/bin/perl
use strict;
use warnings;
use Test::More;
use Method::Signatures;
use lib '../lib';
use Vetstoria;

my $vetstoria = undef;
my $hospital_hash = undef;
my $vetstoria_url = undef;

Given qr/a usable (\S+) module/, sub {
   $vetstoria = Vetstoria->new();
   use_ok( $1 );
};

Given qr/the hospital hash is "([^"]*)"/, sub {
   $hospital_hash = $1;
   ok $hospital_hash, "got hospital_hash";
};

Given qr/the web site in the url is "([^"]*)"/, sub {
   $vetstoria_url = $1;
   ok $vetstoria_url, "got vetstoria_url";
};

When qr/given the client and patient parameters "([^"]*)" and ((.*))/, func($c) {
   my $client = $1;
   my $patient_list = $2;
   $patient_list =~ s/"//g;
   $patient_list = substr($patient_list, 1, length($patient_list)-2);
   #print "client = $client\n";
   #print "patients = $patient_list\n";
   my @patients = split(/,/, $patient_list);
   my $url = $vetstoria->CreateURL($hospital_hash, $client, [ @patients ]);    
   if (substr($url, 0, length($vetstoria_url)) ne $vetstoria_url) {
      fail "The vetstoria url is incorrect, saw '" . substr($url, 0, length($vetstoria_url)) . "'";
   }
   if ((split(/\//, $url))[3] ne $hospital_hash) {
      fail "the hospital hash is incorrect, saw " . (split(/\//, $url))[3];
   }
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
