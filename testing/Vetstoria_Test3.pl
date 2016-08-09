#!/usr/bin/perl -w

use strict;
use lib '../lib';
use Vetstoria;

my $vetstoria = Vetstoria->new();
my $url;
my($hosp, $client, $patient) = ('', '', '');

my @samples = (
["22593", ["48815:37",       "48815:C302", "48815:V199"],  ["Total Health with UA","Bi-Annual Wellness Exam","Rabies Vaccine & Exam"],                   ],
["18577", ["40594:37811061", "40594:5010", "40594:5010"],  ["Heartworm Medication Refill","Intestinal Parasite Screen","Intestinal Parasite Screen"],    ],
["22369", ["48354:V199",     "48354:V199", "48354:C303"],  ["Rabies Vaccine & Exam","Rabies Vaccine & Exam","Annual Wellness Exam"],                     ],
["18767", ["44249:C302",     "44249:5010", "44249:5010"],  ["Bi-Annual Wellness Exam","Intestinal Parasite Screen","Intestinal Parasite Screen"],        ],
["16343", ["34990:C302",     "34990:L152", "34990:L152"],  ["Bi-Annual Wellness Exam","Heartworm & Tick Fever Screen","Heartworm & Tick Fever Screen"],  ],
["22777", ["49176:V173",     "49176:V154", "49176:S129"],  ["FVRCP 3rd Booster & Exam","Leukemia Booster #2 & Exam","Your Pet Needs to be Neutered"],    ],
["19947", ["43405:C302",     "45902:C302", "45902:910"],   ["Bi-Annual Wellness Exam","Bi-Annual Wellness Exam","Urinalysis (Referral Lab]"],            ],
["15511", ["43855:2807",     "43855:1370", "43855:C302"],  ["Bi-Annual Young Wellness","Cholesterol and Triglycerides","Bi-Annual Wellness Exam"],       ],
[" 5266", ["30352:1272",     "30352:C302", "30352:2326"],  ["Bi-Annual Bloodwork","Bi-Annual Wellness Exam","Urinalysis w/ Reflex UPC (If I"],           ],
["21082", ["45751:V230",     "45754:C302", "45754:V230"],  ["Distemper Parvo Vaccine & Exam","Bi-Annual Wellness Exam","Distemper Parvo Vaccine & Exam"],],
["22127", ["47869:V230",     "47869:V199", "47869:C303"],  ["Distemper Parvo Vaccine & Exam","Rabies Vaccine & Exam","Annual Wellness Exam"],           ],
["17747", ["48857:V107",     "48857:C303", "48857:72408"], ["Bordetella Vaccine - 6 Month","Annual Wellness Exam","Nexgard Canine Med. 10-24 lbs"],     ],
["19707", ["42950:V230",     "42950:C302", "42950:V199"],  ["Distemper Parvo Vaccine & Exam","Bi-Annual Wellness Exam","Rabies Vaccine & Exam"],         ],
["20802", ["48642:C303",     "45132:C302", "45132:V109"],  ["Annual Wellness Exam","Bi-Annual Wellness Exam","Bordetella Vaccine - Annual"],             ],
[" 8805", ["48835:C302",     "47154:C303", "47154:V196"],  ["Bi-Annual Wellness Exam","Annual Wellness Exam","Rabies Feline & Exam"]                     ]
);


foreach my $sample (@samples) {
   print "Encoding \"577bbe97a7115\", \"$sample->[0]\", [ " . join(',', @{$sample->[1]}) . " ] yields:\n";
   $url = $vetstoria->CreateURL("577bbe97a7115", $sample->[0], [ @{$sample->[1]} ]);
  ($hosp, $client, $patient) = $vetstoria->DecodeURL($url);
   print "Hospital = '$hosp'\nClient='$client'\nPatient='$patient'\n";
   print "Services are:\n";
   foreach my $desc (@{$sample->[2]}) {
      print "   $desc\n";
   }
   print "$url\n\n";
}

