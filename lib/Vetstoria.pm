package Vetstoria;

use strict;
use warnings;
use MIME::Base64 qw( encode_base64 decode_base64 encode_base64url decode_base64url );
use Crypt::CBC;
 
my $VetstoriaBase_Test = 'https://booking-qa.vetstoria.com/';
my $VetstoriaBase_Prod = 'https://appointments.vetstoria.com/';
my $VetstoriaBase = $VetstoriaBase_Test;

my $EncryptionKey = 'aG@j33K`,2A<2ZsEZK#k\qL9SWd~W}u#J6W"^6$}M@g#!\5}(^"Dtx%3';
my $Debugging = 0;

sub new {
   my ($class) = @_;

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
#    patient(s).   The patient argument may be a single patient id as a
#    scalar or a reference to an array of patient ids.
#    
#    The $HospitalSiteHash is the code supplied by Vetstoria and the 
#    client and patient ids are the PMS ids.
#    
sub CreateURL {
   my ($self, $HospitalSiteHash, $PMS_Client_Id, $PMS_Patient_Id) = @_;
   
   # If the patient id is not already an array reference, make it one...
   unless (ref($PMS_Patient_Id) eq 'ARRAY') {
      $PMS_Patient_Id = [ $PMS_Patient_Id ];
   }
   
   my @patient_list = ();
   foreach my $pet (@{$PMS_Patient_Id}) {
      push @patient_list, ("{ \"p_id\": \"$pet\" }") if $pet; 
   }
   
   my $url = $VetstoriaBase . $HospitalSiteHash . '/';
   my $json = "{\"c_id\":\"$PMS_Client_Id\", \"pets\":[ " . join(', ', @patient_list) . " ]}";
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
   print "json = $json\n" if $Debugging;
   $json =~ /"c_id":"([^"]*)", "pets":\[([^\]]*)\]/;
   return ($hospital, $1, $2);
   
}
#=======================================================================


1;

