#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Term::ANSIColor;
use HTML::Template;

say colored(["bright_green"], "WSSB DEFECTS REPORT PROCESSOR v1.1 (GPL 2.0) ");

print colored (["bright_yellow"], "Press <ENTER> to generate Inspection Defects Report (Quarters G)");
<>;

my $floor_index = { "f0" => "Ground Floor", 
                    "f1" => "1st Floor", "f2" => "2nd Floor",
                    "f3" => "3rd Floor", "f4" => "4th Floor",
                    "f5" => "5th Floor", "External" => "External" };

# all in one
my $img_folder = "defects_images/all_pictures";
opendir my $fh, $img_folder or die "$!\n";

my $defects_img_ref = get_defects_images( $fh );

generate_report_html ( $img_folder, $defects_img_ref, 
    "report_template.html" => "defects_report_sparse/all-defects.html" );
    
closedir $fh;

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
    @images = sort @images;

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
    my $defects_img_ref = shift; # all images
    my $template = shift;
    my $output_file = shift;
    
    my $report = HTML::Template->new( filename => 'report_template.html' );
    
    # transform data first
    my $template_data = [];
    my $page = 1;
    for ( @$defects_img_ref ) {

        my @details = split ( /\_/ => (split(/\./, $_)) [0] );
        $details[3] =~ s/\-/ /g; # Room
        $details[4] =~ s/\-/ /g; # Description
        
        push @$template_data, {
            #"img_path" => "../$img_folder/$_",
            "page" => $page++,
            "img_path" => "/$_",
            "location" => $floor_index->{ $details[2] },
            "room" => $details[3],
            "description" => $details[4]
        };
    }
    
    
    $report->param( "defects" => $template_data );
    
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







