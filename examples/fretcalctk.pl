#!/usr/bin/perl -w
###############################################################
# fretcalctk.pl                                               #
# Copyright (c) 2002 Douglas S Sparling. All rights reserved. #
# This program is free software; you can redistribute it      #
# and/or modify it under the same terms as Perl itself.       #
###############################################################
use strict;
use Tk;
use Tk::Dialog;
use Lutherie::FretCalc;

my $VERSION = '0.1';

my $rb1 = 0; # Method
my $rb2 = 0; # Precision
#my $rb3 = 0; # Scale Length Type

my $mw = MainWindow->new();

# Set app size and center
my $screen_width = $mw->screenwidth;
my $screen_height = $mw->screenheight;
my $pos_x = $screen_width / 2;
my $pos_y = $screen_height / 2;
#my $size_x = 500;
my $size_x = 400;
#my $size_y = 335;
my $size_y = 365;
$mw->geometry($size_x.'x'.$size_y.'+'.$pos_x.'+'.$pos_y);

# Disable window resize
$mw->resizable(0,0);

# Set the title
$mw->title("FretCalcTk $VERSION");

# Create the menubar
my $menubar = $mw->Frame(-relief => 'raised',
                         -borderwidth => 2,
)->place(-x => 0, -y => 0, -relwidth => 1.0);

# Create the menubuttons
my $menu_file = $menubar->Menubutton(-text => 'File',
                                     -underline => 0,
                                     -tearoff => 0
)->pack(-side => 'left');

my $menu_calc = $menubar->Menubutton(-text => 'Calc',
                                        -underline => 0,
                                        -tearoff => 0
)->pack(-side => 'left');


my $menu_help = $menubar->Menubutton(-text => 'Help',
                                     -underline => 0,
                                     -tearoff => 0
)->pack(-side => 'left');

# Create menu items

# File menu items
$menu_file->command(-label => 'Print',
                    -command => [\&print, 'Print not implemented'],
                    -underline => 1);

$menu_file->separator();

$menu_file->command(-label => 'Exit',
                    -command => sub { exit },
                    -underline => 1);

# Calc menu items
# Mode Cascade
my $menu_mode_cascade = $menu_calc->menu->Menu();

$menu_mode_cascade->radiobutton(-label => 'Standard',
                           -command => \&mode,
                           -variable => \$rb1,
                           -value => 'Standard');

$menu_mode_cascade->radiobutton(-label => 'Dulcimer',
                           -command => \&mode,
                           -variable => \$rb1,
                           -value => 'Dulcimer');

$menu_calc->cascade(-label => 'Mode');

$menu_calc->entryconfigure('Mode', -menu => $menu_mode_cascade);

$menu_calc->separator();

# Precision Cascade
my $menu_prec_cascade = $menu_calc->menu->Menu();

$menu_prec_cascade->radiobutton(-label => '.1',
                           #-command => \&display_radiobutton2,
                           -variable => \$rb2,
                           -value => '.1');

$menu_prec_cascade->radiobutton(-label => '.01',
                           #-command => \&display_radiobutton2,
                           -variable => \$rb2,
                           -value => '.01');

$menu_prec_cascade->radiobutton(-label => '.001',
                           #-command => \&display_radiobutton2,
                           -variable => \$rb2,
                           -value => '.001');

$menu_prec_cascade->radiobutton(-label => '.0001',
                           #-command => \&display_radiobutton2,
                           -variable => \$rb2,
                           -value => '.0001');


$menu_calc->cascade(-label => 'Precision');

$menu_calc->entryconfigure('Precision', -menu => $menu_prec_cascade);


# Help menu items
$menu_help->command(-label => 'Help',
                    -command => [\&help, 'Help not implemented']);

$menu_help->separator();

$menu_help->command(-label => 'About',
                    -command => [\&about_dialog]);


# About Dialog
my $dialog_text = "FretCalcTk $VERSION\n\n";
$dialog_text .= "Copyright 2002 Douglas S. Sparling. All rights reserved.\n\n".
                "This program is free software; you can redistribute it ".
                "and/or modify it under the same terms as Perl itself.\n\n";
$dialog_text .= 'doug@dougsparling.com' . "\n";
$dialog_text .= 'http://www.dougsparling.com/software/fretcalc/' . "\n";
my $dialog_title = "FretCalcTk $VERSION";
my $dialog = $mw->Dialog(-text => $dialog_text, -title => $dialog_title,
                         -default_button => 'OK', -buttons => [qw/OK/]);


### Place our widgets ###
#my $text = $mw->Text()->place(-x => 0, -y => 28, -height => 400, -width => 180);
my $text = $mw->Scrolled('Text', -scrollbars => 'e')->place(-x => 0, -y => 28, -height => 330, -width => 180);


$mw->Label(-text => 'Scale Length')->place(-x => 180, -y => 30);
my $scale_length = $mw->Entry(-validate => 'key',
                          -validatecommand => sub {
                          my($proposed, $chars, $current, $index, $type) = @_;
                          return $proposed =~ /^[\d\.\s]*$/;
                          },                          
)->place(-x => 180, -y => 50, -width => 80);

#$mw->Label(-text => 'Calc Method')->place(-x => 180, -y => 150);
#$mw->Label(-text => 'Settings')->place(-x => 180, -y => 250);

$mw->Label(-text => 'Number of Frets')->place(-x => 280, -y => 30);
my $num_frets = $mw->Entry(-validate => 'key',
                          -validatecommand => sub {
                          my($proposed, $chars, $current, $index, $type) = @_;
                          return $proposed =~ /^[\d\s]*$/;
                          },                          
)->place(-x => 280, -y => 50, -width => 80);

#$mw->Label(-text => 'Half Frets')->place(-x => 280, -y => 150);

$mw->Button(-text => 'Calculate',
            -command => \& calculate)->place(-x => 180, -y => 300);
$mw->Button(-text => 'Exit',
            -command => sub { exit })->place(-x => 280, -y => 300);


# Initialize
$scale_length->focus();
$rb1 = 'Standard';
$rb2 = '.001';
my $item = "Fret\tDist from Nut\n";
$text->delete('1.0', 'end');
$text->insert('end', $item);

MainLoop;

### Subs ###

sub calculate {

    my $fretcalc = Lutherie::FretCalc->new();
    my $sl = $scale_length->get();
    my $nf = $num_frets->get();

    $fretcalc->scale($sl);
    $fretcalc->num_frets($nf);

    my @chart = $fretcalc->fretcalc();

    my $item = "Fret\tDist from Nut\n";
    for my $fret(1..$#chart) {
        $fret = sprintf("%3d",$fret);
        my $dist = $chart[$fret];

        # Set precision
        if ($rb2 == .1) {
            $dist = sprintf("%.1f",$dist);
        } elsif ($rb2 == .01) {
            $dist = sprintf("%.2f",$dist);
        } elsif ($rb2 == .001) {
            $dist = sprintf("%.3f",$dist);
        } elsif ($rb2 == .0001) {
            $dist = sprintf("%.4f",$dist);
        }
    
        $item .= "$fret\t$dist\n";
    }
    chomp $item;

    $text->delete('1.0', 'end');
    $text->insert('end', $item);
}

sub about_dialog {

    $dialog->Show();
}

### Stubs ###
sub print {
    my ($item) = @_;
    print "$item\n";
}

sub help {
    my ($item) = @_;
    print "$item\n";
}

sub mode {
    print "Mode not implemented\n";
}
