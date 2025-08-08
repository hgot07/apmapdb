#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Text::CSV_XS;
use Spreadsheet::ParseXLSX;
use Encode;

my $outform = '';
if ( $0 =~ /apmap-eduroamJP/ ){
	$outform = 'eduroamJP';
} elsif ( $0 =~ /apmap-kml/ ){
	$outform = 'kml';
} else {
	print "Wrong command name.\n";
	exit(1);
}

my $fname = shift;
if ( ! $fname ){
	if ( $outform eq 'eduroamJP' ){
		print "Convert AP map data in CSV (UTF-8) or Excel (.xlsx) to eduroam JP-style CSV\n  ver.20250809\n";
		print "Usage: $0 <.csv/.xlsx file> > outfile.csv\n";
	} else {
		print "Convert AP map data in CSV (UTF-8) or Excel (.xlsx) to KML (Placemark only)\n  ver.20250809\n";
		print "Usage: $0 <.csv/.xlsx file> > outfile.kml\n";
	}
	exit(1);
}
my $filetype = '';
if ( $fname =~ /\.csv$/i ){
	$filetype = 'csv';
} elsif ( $fname =~ /\.xlsx$/i ){
	$filetype = 'xlsx';
} else {
	print "Not a CSV or Excel file.\n";
	exit(1);
}

# UTF-8 BOM for CSV file
if ( $outform eq 'eduroamJP' ){
	print "\xEF\xBB\xBF";
}

my $lat0 = 0;
my $lon0 = 0;


if ( $filetype eq 'csv' ){

my $csv = Text::CSV_XS->new();

open(my $fh, '<:encoding(utf8)', $fname) or die ("Error: $!\n");
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
# template version 20250804:
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

	if ( $outform eq 'eduroamJP' ){
		print_pm_eduroamJP(\@m, \%c);
	} else {
		print_pm_kml(\@m, \%c);
	}
}

close($fh);

} elsif ( $filetype eq 'xlsx' ){

my $parser = Spreadsheet::ParseXLSX->new;
my $workbook = $parser->parse($fname);
if ( !defined $workbook ) {
	die $parser->error(), ".\n";
}

for my $worksheet ( $workbook->worksheets() ) {
	my $wsname = $worksheet->get_name();
	next if ( $wsname !~ /^APdata/ );
 
	my ( $row_min, $row_max ) = $worksheet->row_range();
	my ( $col_min, $col_max ) = $worksheet->col_range();
	next if ( $col_min != 0 );
 
	my %c;
	for my $row ( $row_min .. $row_max ) {
		my $cell = $worksheet->get_cell( $row, 0 );
		next if ( ! defined $cell );
		my $visibility = $cell->unformatted();
		$cell = $worksheet->get_cell( $row, 1 );
		next if ( ! defined $cell );
		my $status = $cell->unformatted();

		if ( $visibility eq 'visibility' ){
			my $i = 0;
			for my $col ( $col_min .. $col_max ) {
				$cell = $worksheet->get_cell( $row, $i );
				$c{ $cell->unformatted() } = $i++;
			}
			next;
		}

		next if ( $visibility ne '公開' && $visibility ne 'open' );
		next if ( $status ne '本格運用' && $visibility ne 'production' );

		my @m;
		for my $col ( $col_min .. $col_max ) {
			$cell = $worksheet->get_cell( $row, $col );
			if ( defined $cell ){
#				push(@m, $cell->unformatted());
				push(@m, $cell->value());
			} else {
				push(@m, '');
			}
		}

		my $loc_name = $m[ $c{'loc_name_en'} ];
		if ( $m[ $c{'loc_name'} ] ){ $loc_name = $m[ $c{'loc_name'} ]; }

		my $lat = $m[ $c{'latitude'} ];
		my $lon = $m[ $c{'longitude'} ];

		# coordinate check for Japan
		if ( $lat > 46 || $lon < 122 ){
			print STDERR "Wrong coordinate at $row: $lon, $lat\n";
			next;
		}

		next if ( $lon == $lon0 && $lat == $lat0 );
		$lat0 = $lat;
		$lon0 = $lon;

		if ( $outform eq 'eduroamJP' ){
			print_pm_eduroamJP(\@m, \%c);
		} else {
			print_pm_kml(\@m, \%c);
		}

	}
}

}

exit(0);


sub print_pm_eduroamJP {
	my ($m_ref, $c_ref) = @_;
	my @m = @$m_ref;
	my %c = %$c_ref;

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


sub print_pm_kml {
	my ($m_ref, $c_ref) = @_;
	my @m = @$m_ref;
	my %c = %$c_ref;

	my $loc_name = $m[ $c{'loc_name_en'} ];
	if ( $m[ $c{'loc_name'} ] ){ $loc_name = $m[ $c{'loc_name'} ]; }

	my $lat = $m[ $c{'latitude'} ];
	my $lon = $m[ $c{'longitude'} ];

	my $svc_name = $m[ $c{'op_short'} ];
	if ( $m[ $c{'svc_name'} ] ){
		$svc_name = $m[ $c{'svc_name'} ];
		$svc_name .= " ($m[ $c{'op_short'} ])";
	}

my $pm = <<EOS;
    <Placemark>
      <name>$loc_name</name>
      <description><![CDATA[$svc_name<br>eduroam, Cityroam, OpenRoaming]]></description>
      <styleUrl>#icon-1899-0288D1</styleUrl>
      <Point>
        <coordinates>
          $lon,$lat,0
        </coordinates>
      </Point>
    </Placemark>
EOS

	print encode('utf8', $pm);
}


