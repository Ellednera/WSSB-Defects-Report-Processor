#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Term::ANSIColor;
use HTML::Template;

say colored(["bright_green"], "WSSB DEFECTS REPORT PROCESSOR v1.0 (GPL 2.0) ");

print colored (["bright_yellow"], "Press <ENTER> to generate Inspection Defects Report (Quarters G)");
<>;

my $floor_index = { "f0" => "Ground Floor", 
                    "f1" => "1st Floor", "f2" => "2nd Floor",
                    "f3" => "3rd Floor", "f4" => "4th Floor",
                    "External" => "External" };

my $img_folder = "defects_images";
my $fh;
opendir $fh, $img_folder or die "$!\n";

my $defects_img_ref = get_defects_images( $fh );

closedir $fh;

#generate_report( $defects_img_ref );
generate_report_html ( $img_folder, $defects_img_ref, 
    "report_template.html" => "defects_report_3.html" );

print colored (["bright_yellow"], "Program ended successfully. Press <ENTER> to quit...");
<>;

# besiyata d'shmaya


sub get_defects_images {
    # only the filename
    my $fh = shift;
    my @images;
    
    for ( readdir( $fh ) ) {
        # no more grouping, grouped pictures not so clear on paper
        if ( $_ =~ /^qg.*\.jpe?g/i ) {
            push @images, $_;
        }
    }
    
    \@images;
};

sub generate_report {
    my $defects_ref = shift;
    for ( keys @$defects_ref ) {
        process_this_defect( $defects_ref->[ $_ ] );
        say ""; # divider
    }
};

sub generate_report_html {
    my $img_folder = shift;
    my $defects_ref = shift;
    my $template = shift;
    my $output_file = shift;
    
    my $report = HTML::Template->new( filename => 'report_template.html' );
    $report->param( img_path => "$img_folder/qg_300_f0_Unit-A-(Bilik-air-1)_Hole-on-wall.jpg" );
    
    open my $fh, ">", "$output_file" or die "Can't generate report in HTML format. $!\n";
    print $fh $report->output;
    close $fh;
}

sub process_this_defect {
    my $defect_details = shift; # single filename
    
    # say "Processing \"", $defect_details, "\" . . .";
    
    # this is only a copy
    # ignore extension, split by _
    my @details = split ( /\_/ => (split(/\./, $defect_details)) [0] );
    $details[3] =~ s/\-/ /g; # Room
    $details[4] =~ s/\-/ /g; # Description
    
    generate_defect_details( \@details );
};

sub generate_defect_details {
    my $details = shift;
    # print report
    say colored (["bright_cyan"], "[$details->[1]]");
    say "Location: ", $floor_index->{ $details->[2] };
    say "Room: ", $details->[3];
    say "Status: Minor"; # most are minor defects
    say "Description: ", $details->[4];
    say "Proposed date of completion/repairing by"
}







