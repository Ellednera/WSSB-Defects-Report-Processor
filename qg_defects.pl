#usr/bin/perl

use strict;
use warnings;
use 5.010;

use Term::ANSIColor::WithWin32;
use Win32::Console::ANSI;

say colored(["bright_green"], "WSSB DEFECTS REPORT PROCESSOR v1.0 (GPL 2.0) ");

say colored (["bright_yellow"], "Press <ENTER> to generate Inspection Defects Report (Quarters G)");
<>;

my $floor_index = { "f0" => "Ground Floor", 
                    "f1" => "1st Floor", "f2" => "2nd Floor",
                    "f3" => "3rd Floor", "f4" => "4th Floor",
                    "unknown" => "(Unknown)" };

my $fh;
opendir $fh, "./";

my $defects_img_ref = get_defects_images( $fh );

closedir $fh;

generate_report( $defects_img_ref );

print colored (["bright_yellow"], "Program ended successfully. Press <ENTER> to quit...");
<>;

# besiyata d'shmaya


sub get_defects_images {
    # only the filename
    my $fh = shift;
    my @images;
    
    for ( readdir( $fh ) ) {
    
        # group of defects (folder), put in front of report
        if ( -d and ($_ =~ /^qg/) ) {
            unshift @images, $_;
        }
        
        # invididual defects
        if ( -f  and ($_ =~ /^qg/) and ( ($_ =~ /.jpe?g$/i) or ($_ =~ /.png$/i) ) ) {
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

sub process_this_defect {
    my $defect_details = shift; # single filename
    
    # say "Processing \"", $defect_details, "\" . . .";
    
    # this is only a copy
    # ignore extension, split by _
    my @details = split ( /\_/ => (split(/\./, $defect_details)) [0] );
    $details[3] =~ s/\-/ /g; # Room
    $details[4] =~ s/\-/ /g; # Description
    
    # print report
    say colored (["bright_cyan"], "[$details[1]]");
    say "Location: ", $floor_index->{ $details[2] };
    say "Room: ", $details[3];
    say "Status: Minor"; # most are minor defects
    say "Description: ", $details[4];
    say "Proposed date of completion/repairing by"
};







