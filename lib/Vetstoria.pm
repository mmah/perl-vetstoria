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


sub CreateURL {
   my ($self, $HospitalSiteHash, $PMS_Client_Id, $PMS_Patient_Id) = @_;
   
   my $url = $VetstoriaBase . $HospitalSiteHash . '/';
   my $json = "{\"c_id\":\"$PMS_Client_Id\", \"p_id\":\"$PMS_Patient_Id\"}";
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
   $json =~ /"c_id":"([^"]*)", "p_id":"([^"]*?)"/;
   return ($hospital, $1, $2);
   
}
#=======================================================================


1;

