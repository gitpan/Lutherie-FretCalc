#!/usr/bin/perl -w
use strict;
use CGI qw/:standard/;
use Lutherie::FretCalc qw/fretcalc/;

# Limit number of frets
my $MAX_FRETS = 50;

print header,
      start_html(-title=>'FretCalc'),
      h1('Fret Placement Calculator'),
      startform,
      table(TR,
             td('Scale Length:'),
             td(textfield(-name=>'scale_length')),
             td(radio_group(-name=>'scale_type',
                            -values=>['inches','millimeters'],
                            -default=>'inches')),
           TR,
             td('Number of Frets:'), 
             td(textfield(-name=>'num_frets')),
             td(radio_group(-name=>'position_type',
                            -values=>['inches','millimeters'],
                            -default=>'inches')),
          
      ),
      submit,
      endform;

# Display results if scale_length is numeric
if( param('scale_length') =~ /^\d+$/ ) {

    # Get params
    my $scale_length = param('scale_length');
    my $num_frets = param('num_frets');
    my $scale_type = param('scale_type');
    my $position_type = param('position_type');

    # Check $num_frets
    $num_frets = $MAX_FRETS unless $num_frets =~ /^\d+$/;
    $num_frets = $MAX_FRETS if $num_frets > $MAX_FRETS;

    $scale_type = 'in' if $scale_type eq 'inches';
    $scale_type = 'mm' if $scale_type eq 'millimeters';
    $position_type = 'in' if $position_type eq 'inches';
    $position_type = 'mm' if $position_type eq 'millimeters';

    my @frets = fretcalc($scale_length,$num_frets,$scale_type,$position_type);

    print hr,
          '<table border=1>',
          '<th>Fret</th>',
          '<th>Dist from Nut</th>';

    foreach my $i (1..$#frets) {
        my $fret = sprintf("%3d",$i);
        print '<tr>',
              qq!<td align="right">$fret</td>!,
              qq!<td align="right">$frets[$i]</td>!,
              '</tr>';
    }
    print '</table>';

} else {

    print hr,
          'Scale length must be numeric';
 }
     

print end_html;
