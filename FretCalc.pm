# Copyright (c) 2001 Douglas Sparling. All rights reserved. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.

package Lutherie::FretCalc;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter);
@EXPORT_OK = qw(fretcalc fret);
@EXPORT = ();

$VERSION = '0.16';

sub fretcalc {

    die "Not enough arguments to fretcalc()\n" if @_ < 4;
    my($scale_length,$num_frets,$in_units,$out_units,
       $calc_method,$tet) = @_;
    $calc_method = 't' if !defined $calc_method;
    $tet = 12 if !defined $tet;

    my $distance_from_nut = 0;
    my $distance_from_nut_formatted;

    my @chart;
    $chart[0] = sprintf("%8.4f",0) if $out_units eq 'in';
    $chart[0] = sprintf("%8.1f",0) if $out_units eq 'mm';

    for my $i (1..$num_frets) {
        if ($calc_method eq 't') {
            $distance_from_nut = ($scale_length - $scale_length/2 ** ($i/$tet));
        } elsif ($calc_method eq 'ec') {
            my $x = ($scale_length - $distance_from_nut) / 17.817;
            $distance_from_nut += $x;
        } elsif ($calc_method eq 'es') {
            my $x = ($scale_length - $distance_from_nut) / 17.835;
            $distance_from_nut += $x;
        } elsif ($calc_method eq 'ep') {
            my $x = ($scale_length - $distance_from_nut) / 18;
            $distance_from_nut += $x;
        } else {
            $distance_from_nut = ($scale_length - $scale_length/2 ** ($i/12));
        }

        ### input scale: in, output scale: in
        if( ($in_units eq 'in') && ($out_units eq 'in') ) {
            $distance_from_nut_formatted = sprintf("%8.4f",$distance_from_nut);
        ### input scale: in, output scale: mm
        } elsif( ($in_units eq 'in') && ($out_units eq 'mm') ) {
            $distance_from_nut *= 25.4;
            $distance_from_nut_formatted = sprintf("%8.1f",$distance_from_nut);
        ### input scale: mm, output scale: in
        } elsif( ($in_units eq 'mm') && ($out_units eq 'in') ) {
            $distance_from_nut /=  25.4;
            $distance_from_nut_formatted = sprintf("%8.4f",$distance_from_nut);
        #### input scale: mm, out_units: mm
        } else {
            $distance_from_nut_formatted = sprintf("%8.1f",$distance_from_nut);
        }
        push @chart, $distance_from_nut_formatted;
    }
    return @chart;

}

sub fret {

    die "Not enough arguments to fret()\n" if @_ < 4;
    my($scale_length,$fret_num,$in_units,$out_units,$calc_method,$tet) = @_;

    $calc_method = 't' if !defined $calc_method;
    $tet = 12 if !defined $tet;

    my $distance_from_nut = 0;
    my $distance_from_nut_formatted;
    if ($calc_method eq 't') {
        $distance_from_nut = ($scale_length - $scale_length/2 ** ($fret_num/$tet));
    } elsif ($calc_method eq 'ec') {
        for my $i (1..$fret_num) {
            my $x = ($scale_length - $distance_from_nut) / 17.817;
            $distance_from_nut += $x;
        }
    } elsif ($calc_method eq 'es') {
        for my $i (1..$fret_num) {
            my $x = ($scale_length - $distance_from_nut) / 17.835;
            $distance_from_nut += $x;
        }
    } elsif ($calc_method eq 'ep') {
        for my $i (1..$fret_num) {
            my $x = ($scale_length - $distance_from_nut) / 18;
            $distance_from_nut += $x;
        }
    } else {
        $distance_from_nut = ($scale_length - $scale_length/2 ** ($fret_num/$tet));
    }

    ### in_units: in, out_units: in
    if( ($in_units eq 'in') && ($out_units eq 'in') ) {
        $distance_from_nut_formatted = sprintf("%8.4f",$distance_from_nut);
    ### in_units: in, out_units: mm
    } elsif( ($in_units eq 'in') && ($out_units eq 'mm') ) { 
        $distance_from_nut *= 25.4;
        $distance_from_nut_formatted = sprintf("%8.1f",$distance_from_nut);
    ### in_units: mm, out_units: in
    } elsif( ($in_units eq 'mm') && ($out_units eq 'in') ) {
        $distance_from_nut /= 25.4;
        $distance_from_nut_formatted = sprintf("%8.4f",$distance_from_nut);
    ### in_units: mm, out_units: mm
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

  my $fret = fret($scale_length,$fret_num,$in_units,$out_units,$calc_method);
  my @chart = fretcalc($scale_length,$num_frets,$in_units,$out_units,
                       $calc_method,$tet);


=head1 DESCRIPTION

C<Lutherie::FretCalc> provides two routines for calculating fret spacing 
locations for stringed musical instruments. C<fret()> will find the distance 
from the nut for a given fret number. C<fretcalc()> will generate an array 
containing the fret locations for the given number of frets.

=head2 C<fret()>

=over 4

=item *

C<$scale_length> - Numeric scale length (int or float)

=item *

C<$fret_num> - Fret number being calculated (int)

=item *

C<$in_units> - Scale to be used for the input (Scale length):
'in' (inches) or 'mm' (millimeters) (int of float)

=item *

C<$out_units> - Scale to be used when displaying the calculations:
'in' (inches) or 'mm' (millimeters) (int or float)

=item *

C<$calc_method> - Calculation method (optional): 
't': tempered - power of $i/$tet (default),
'ec': classic - 17.817,
'es': Sloane - 17.835,
'ep': Primative - 18

=item *

C<$tet> - Tones per Octave (optional, $calc_mode='t' only: default=12) (int)

=back

=head2 C<fretcalc()>

=over 4

=item *

C<$scale_length> - Numeric scale length (int of float)

=item *

C<$num_frets> - Number of frets to be calculated (int)

=item *

C<$in_units> - Scale to be used for the input (Scale length):
'in' (inches) or 'mm' (millimeters)

=item *

C<$out_units> - Scale to be used when displaying the calculations:
'in' (inches) or 'mm' (millimeters) (int or float)

=item *

C<$calc_method> - Calculation method (optional): 
't': tempered - power of $i/$tet (default),
'ec': classic - 17.817,
'es': Sloane - 17.835,
'ep': Primative - 18

=item *

C<$tet> - Tones per Octave (optional, $calc_mode='t' only: default=12) (int)

=back

=head1 AUTHOR

Doug Sparling, doug@dougsparling.com

=head1 COPYRIGHT

Copyright (c) 2001 Douglas Sparling. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=cut
