#!/usr/bin/perl -w
use strict;
use Lutherie::FretCalc qw/fret fretcalc/;

my $scale_length = 25;
my $num_frets = 24;
my $in_units = 'in';
my $out_units = 'in';
my $calc_method = 't';
my $tet = 12;

my @chart = fretcalc($scale_length, $num_frets, $in_units, $out_units,
                     $calc_method,$tet);

for my $fret(1..$#chart) {
    $fret = sprintf("%3d",$fret);
    print "Fret $fret: $chart[$fret]\n";
}

print "\n\n";

my $fret_num = 2;
my $fret = fret($scale_length,$fret_num,$in_units,$out_units,$calc_method,$tet);
$fret_num = sprintf("%3d",$fret_num);
print "Fret $fret_num: $fret\n";
