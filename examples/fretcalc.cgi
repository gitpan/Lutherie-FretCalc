#!/usr/bin/perl -w
use strict;
use CGI qw/:standard/;
use Lutherie::FretCalc;

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

display_results() if param();

print end_html;

################################################

sub display_results {

  # Display results if scale_length is numeric
  if( param('scale_length') =~ /^\d+\.?\d+$/ &&
      param('num_frets') =~ /^\d+$/) {

      # Get params
      my $scale_length = param('scale_length');
      my $num_frets = param('num_frets');
      my $in_units = param('scale_type');
      my $out_units = param('position_type');

      # Check $num_frets
      $num_frets = $MAX_FRETS unless $num_frets =~ /^\d+$/;
      $num_frets = $MAX_FRETS if $num_frets > $MAX_FRETS;

      $in_units = 'in' if $in_units eq 'inches';
      $in_units = 'mm' if $in_units eq 'millimeters';
      $out_units = 'in' if $out_units eq 'inches';
      $out_units = 'mm' if $out_units eq 'millimeters';

      my $fretcalc = Lutherie::FretCalc->new($scale_length);
      $fretcalc->num_frets($num_frets);
      $fretcalc->in_units($in_units);
      $fretcalc->out_units($out_units);
      my @frets = $fretcalc->fretcalc();

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
            "'Scale length' and 'number of frets' must be numeric";
   }
     
}
