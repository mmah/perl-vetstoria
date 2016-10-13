package Vetstoria;

use strict;
use warnings;
use MIME::Base64 qw( encode_base64 decode_base64 encode_base64url decode_base64url );
use Crypt::CBC;
 
my $VetstoriaBase_Test = 'https://booking-qa.vetstoria.com/';
my $VetstoriaBase_Prod = 'https://nva.vetstoria.com/';
my $VetstoriaBase = $VetstoriaBase_Prod;

my $EncryptionKey = 'aG@j33K`,2A<2ZsEZK#k\qL9SWd~W}u#J6W"^6$}M@g#!\5}(^"Dtx%3';
my $Debugging = 0;
my $Use_V2 = 1;
my $Include_Reason = 0;

sub new {
   my ($class, $options) = @_;

   if (defined($options)) {
      $Debugging       = $options->{debug}          if (exists($options->{debug}));
      $Use_V2          = $options->{use_v2}         if (exists($options->{use_v2}));
      $Include_Reason  = $options->{include_reason} if (exists($options->{include_reason}));
      if (exists($options->{test}) && ($options->{test})) {
         $VetstoriaBase = $VetstoriaBase_Test;
      }
   }

   my $self = {
      cipher    => Crypt::CBC->new( -key            => $EncryptionKey,
                                    -cipher         => 'Blowfish',
#                                    -iv => '12345678',
                                    -regenerate_key => 0,
                                    -padding        => 'null',
                                    -prepend_iv     => 0,
                                    -header         => 'randomiv'
                                  ),
   };
   bless $self, $class;

   return $self;
}
#=======================================================================


#
# CreateURL - Create a vetstoria URL for the given hospital, client, and 
#    patient(s).   The patient argument may be a single patient item as a
#    scalar or a reference to an array of patient items.  
#
#    The "patient items" consist of either a pms patient id or a pms 
#    patient id and the pms service separated by a colon.
#    
#    The $HospitalSiteHash is the code supplied by Vetstoria and the 
#    client and patient ids are the PMS ids.
#    
sub CreateURL {
   my ($self, $HospitalSiteHash, $PMS_Client_Id, $PMS_Patient_Id) = @_;

   my @patient_list = (); # The list of patients to be included
   my %patient_ids = ();  # This is used to check for duplicate patients or patient:reason codes
   
   # If the patient id is an array reference...
   if (ref($PMS_Patient_Id) eq 'ARRAY') {
      # Step through the array and split the patient ids into 
      #    patient_id and reference code if a colon is found...
      foreach my $pet (@{$PMS_Patient_Id}) {
         #print "Examining pet $pet\n";
         if (length($pet) > 0) {
            my @fields = split(':', $pet);
            if (scalar(@fields) > 1) {
               if ($Include_Reason) {
                  unless (exists($patient_ids{"$fields[0]:$fields[1]"})) {
                     $patient_ids{"$fields[0]:$fields[1]"} = 1;
                     push @patient_list, ("{ \"p_id\" : \"$fields[0]\", \"rfa_id\":\"$fields[1]\" }"); 
                  }
               } else {
                  unless (exists($patient_ids{$fields[0]})) {
                     $patient_ids{$fields[0]} = 1;
                     push @patient_list, ("{ \"p_id\" : \"$fields[0]\" }"); 
                  }
               }
            } else  {
               unless (exists($patient_ids{$fields[0]})) {
                  $patient_ids{$fields[0]} = 1;
                  push @patient_list, ("{ \"p_id\" : \"$fields[0]\" }"); 
              }
            }
         }
      }
   } else {
      if (length($PMS_Patient_Id) > 0) {
         push @patient_list, "{ \"p_id\":\"" . $PMS_Patient_Id . "\" }";
      }
   }
   
   my $pet_element = '';
   if ($Use_V2) {
      $pet_element = "\"pets\":[ " . join(', ', @patient_list) . " ]" if scalar(@patient_list) > 0;
   } else {
      $pet_element = "\"p_id\":\"" . shift(keys(%patient_ids)) . "\"";
   }
   #print "Finished pet_element '$pet_element'\n";
      
   my $url = $VetstoriaBase . $HospitalSiteHash . '/';
   my $json = "{\"c_id\":\"$PMS_Client_Id\"";
   $json .= ", $pet_element ";
   $json .= " }";
   print "json: $json\n" if $Debugging;
   $json = encode_base64url($json);
   print "json base 64: $json\n" if $Debugging;
   $json = $self->{cipher}->encrypt($json);
   print "encrypted json: $json\n" if $Debugging;
   $json = encode_base64url($json);
   print "encrypted json base 64: $json\n" if $Debugging;
   
   return $url . $json;
}
#=======================================================================


#
# DecodeURL - Unpack a supplied Vetstoria URL.
#
sub DecodeURL {
   my ($self, $url) = @_;
   
   my ($hospital, $json) = (split(/\//, $url, 5)) [3..4];

   print "hospital = $hospital\n" if $Debugging;
   
   print "json as in url = $json\n" if $Debugging;
   $json = decode_base64url($json);
   
   print "encoded json = $json\n" if $Debugging;
   $json = $self->{cipher}->decrypt($json);
   print "encoded json base 64= $json\n" if $Debugging;
   $json = decode_base64url($json);
   
   print "Original json = '$json'\n" if $Debugging;
   
   $json =~ s/^\s*\{\s*(.*)\s*\}\s*$//;
   $json = $1;
   print "After initial scrub = '$json'\n" if $Debugging;
   
   $json =~ s/"c_id":"([^"]*)\"//;
   my $client_id = $1;
   print "After client extraction '$json'\n" if $Debugging;
   
   my $pets = '';
   if ($Use_V2) {
      if ($json =~ s/\"pets\":\[([^\]]*)]//) {
         $pets = $1;
      }
   } else {
      if ($json =~ s/\"p_id\":\"([^\"]*)\"//) {
          $pets = $1;
      }
   }
   print "After pet extraction '$json'\n" if $Debugging;
   
   
   return ($hospital, $client_id, $pets);
   
}
#=======================================================================


1;

