#!/usr/bin/perl -w
use strict;
use lib '/home/std1/sparling/doug/perlmodules';
use Lutherie::FretCalc qw/fret fretcalc/;

my $scale_length = 25;
my $num_frets = 12;
my $scale_type = 'in';
my $chart_type = 'in';

#my @chart = fretcalc($scale_length, $num_frets, $scale_type, $chart_type);
my @chart = fretcalc();
for my $fret(1..$#chart) {
    $fret = sprintf("%3d",$fret);
    print "Fret $fret: $chart[$fret]\n";
}

print "\n\n";

my $fret_num = 2;
my $fret = fret($scale_length,$fret_num,$scale_type,$chart_type);
$fret_num = sprintf("%3d",$fret_num);
print "Fret $fret_num: $fret\n";
