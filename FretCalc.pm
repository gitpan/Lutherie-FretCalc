# Copyright (c) 2001 Douglas Sparling. All rights reserved. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.

package Lutherie::FretCalc;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use Carp;

require Exporter;

@ISA = qw(Exporter);
@EXPORT_OK = qw(fretcalc fret);
@EXPORT = ();

$VERSION = '0.14';

sub fretcalc {

    die "Not enough arguments to fretcalc()\n" if @_ < 4;
    my($scale_length,$num_frets,$input_scale,$output_scale) = @_;

    my($distance_from_nut, $distance_from_nut_formatted);

    my @chart;
    $chart[0] = sprintf("%8.4f",0) if $output_scale eq 'in';
    $chart[0] = sprintf("%8.1f",0) if $output_scale eq 'mm';

    for my $i (1..$num_frets) {
        $distance_from_nut = ($scale_length - $scale_length/2 ** ($i/12));

        ### input scale: in, output scale: in
        if( ($input_scale eq 'in') && ($output_scale eq 'in') ) {
            $distance_from_nut_formatted = sprintf("%8.4f",$distance_from_nut);
            push @chart, $distance_from_nut_formatted;
        ### input scale: in, output scale: mm
        } elsif( ($input_scale eq 'in') && ($output_scale eq 'mm') ) {
            $distance_from_nut *= 25.4;
            $distance_from_nut_formatted = sprintf("%8.1f",$distance_from_nut);
            push @chart, $distance_from_nut_formatted;
        ### input scale: mm, output scale: in
        } elsif( ($input_scale eq 'mm') && ($output_scale eq 'in') ) {
            $distance_from_nut /=  25.4;
            $distance_from_nut_formatted = sprintf("%8.4f",$distance_from_nut);
            push @chart, $distance_from_nut_formatted;
        #### input scale: mm, output_scale: mm
        } else {
            $distance_from_nut_formatted = sprintf("%8.1f",$distance_from_nut);
            push @chart, $distance_from_nut_formatted;
        }
    }
    return @chart;

}

sub fret {

    die "Not enough arguments to fret()\n" if @_ < 4;
    my($scale_length,$fret_num,$input_scale,$output_scale) = shift;

    my $distance_from_nut = ($scale_length - $scale_length/2 ** ($fret_num/12));
    my $distance_from_nut_formatted;

    ### input_scale: in, output_scale: in
    if( ($input_scale eq 'in') && ($output_scale eq 'in') ) {
        $distance_from_nut_formatted = sprintf("%8.4f",$distance_from_nut);
    ### input_scale: in, output_scale: mm
    } elsif( ($input_scale eq 'in') && ($output_scale eq 'mm') ) { 
        $distance_from_nut *= 25.4;
        $distance_from_nut_formatted = sprintf("%8.1f",$distance_from_nut);
    ### input_scale: mm, output_scale: in
    } elsif( ($input_scale eq 'mm') && ($output_scale eq 'in') ) {
        $distance_from_nut /= 25.4;
        $distance_from_nut_formatted = sprintf("%8.4f",$distance_from_nut);
    ### input_scale: mm, output_scale: mm
    } else {
        $distance_from_nut_formatted = sprintf("%8.1f",$distance_from_nut);
    }
    return $distance_from_nut_formatted;

}
1;
__END__

=head1 NAME

Lutherie::FretCalc - Calculate stringed instrument fret locations

=head1 SYNOPSIS

  use Lutherie::FretCalc qw/fret fretcalc/;

  my $fret = fret($scale_length,$fret_num,$input_scale,$output_scale);
  my @chart = fretcalc($scale_length,$num_frets,$input_scale,$output_scale);

=head1 DESCRIPTION

C<Lutherie::FretCalc> provides two routines for calculating fret spacing 
locations for stringed musical instruments. C<fret> will find the distance 
from the nut for a given fret number. C<fretcalc> will generate an array 
containing the fret locations for the given number of frets.

C<$scale_length> is the numeric scale length
C<$fret_num> is the fret number being calculated (C<fret> only)
C<$num_frets> is the number of frets to be calculated (C<fretcalc> only)
C<$input_scale> is the scale to be used for the input (Scale length):
'in' (inches) or 'mm' (millimeters)
C<$output_scale> is the scale to be used when displaying the calculations:
'in' (inches) or 'mm' (millimeters)

=head1 AUTHOR

Doug Sparling, doug@dougsparling.com

=head1 COPYRIGHT

Copyright (c) 2001 Douglas Sparling. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=cut
