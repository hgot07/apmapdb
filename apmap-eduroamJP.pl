#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Text::CSV_XS;
use Encode;

my $csv = Text::CSV_XS->new();

my $lon0 = 0;
my $lat0 = 0;

my $file = shift;
if ( ! $file ){
print <<EOS;
Convert AP map data in CSV (UTF-8) to eduroam JP-style CSV  ver.20250804
Usage: $0 <CSV file> > outfile.csv
EOS
	exit(1);
}
if ( $file !~ /\.csv/i ){
	print "Not a CSV file.\n";
	exit(1);
}

# UTF-8 BOM 
print "\xEF\xBB\xBF";

open(my $fh, '<:encoding(utf8)', $file) or die ("Error: $!\n");
my %c;
my $linenum = 0;
while (my $l = <$fh>) {
	$linenum++;
	$csv->parse($l);
	my @m = $csv->fields();
	if ( ! defined $m[0] ){ next; }

	my $visibility = $m[0];
	my $status = $m[1];
	if ( $visibility eq 'visibility' ){
# version 20250804:
# visibility status reg_date remove_date svc_name op_short loc_name
# loc_name_en latitude longitude floor zip CA1 CA3 CA4 CA6
# CA1en CA3en CA4en CA6en venue_url num_ap ssid_list bssid_list area_code
		my $i = 0;
		while( $m[$i] ){
			$c{ $m[$i] } = $i;  $i++;
		}
		next;
	}

	next if ( $visibility ne '公開' && $visibility ne 'open' );
	next if ( $status ne '本格運用' && $visibility ne 'production' );

	my $loc_name = $m[ $c{'loc_name_en'} ];
	if ( $m[ $c{'loc_name'} ] ){ $loc_name = $m[ $c{'loc_name'} ]; }

	my $lat = $m[ $c{'latitude'} ];
	my $lon = $m[ $c{'longitude'} ];

	# coordinate check for Japan
	if ( $lat > 46 || $lon < 122 ){
		print STDERR "Wrong coordinate at CSV line $linenum: $lon, $lat\n";
		next;
	}

	next if ( $lon == $lon0 && $lat == $lat0 );
	$lat0 = $lat;
	$lon0 = $lon;

	my $svc_name = $m[ $c{'op_short'} ];
	if ( $m[ $c{'svc_name'} ] ){
		$svc_name = $m[ $c{'svc_name'} ];
		$svc_name .= " ($m[ $c{'op_short'} ])";
	}

	my $ca6 = 'NA';
	if ( $m[ $c{'CA4en'} ] ne 'NA' && $m[ $c{'CA4en'} ] ne '' ){
		$ca6 = $m[ $c{'CA4en'} ];
	}
	if ( $m[ $c{'CA6en'} ] ne 'NA' && $m[ $c{'CA6en'} ] ne '' ){
		$ca6 = "$m[ $c{'CA6en'} ], $ca6";
	}

my $pm = <<EOS;
項目名,必須,値,入力例,説明
基地局名称(英語),●,"$m[ $c{'loc_name_en'} ]",,
基地局名称(日本語),●,"$m[ $c{'loc_name'} ]",,
基地局経緯度,●,"$m[ $c{'latitude'} ], $m[ $c{'longitude'} ]",,
基地局運用水準,●,本格運用,,
基地局種別,●,シングルスポット,,
基地局所在地 都道府県市区町村(英語),●,"$m[ $c{'CA3en'} ], $m[ $c{'CA1en'} ]",,
基地局所在地 町名番地(英語),●,"$ca6",,
SSID,●,eduroam,,
,,,,
EOS

	print encode('utf8', $pm);
}

close($fh);

