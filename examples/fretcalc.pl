#!/usr/bin/perl -w
use strict;
use Lutherie::FretCalc qw/fret fretcalc/;

my $scale_length = 25;
my $num_frets = 12;
my $input_scale = 'in';
my $output_scale = 'in';

my @chart = fretcalc($scale_length, $num_frets, $input_scale, $output_scale);
for my $fret(1..$#chart) {
    $fret = sprintf("%3d",$fret);
    print "Fret $fret: $chart[$fret]\n";
}

print "\n\n";

my $fret_num = 2;
my $fret = fret($scale_length,$fret_num,$input_scale,$output_scale);
$fret_num = sprintf("%3d",$fret_num);
print "Fret $fret_num: $fret\n";
