#!/usr/bin/perl
#Instructions for usage:
#perl extractor.pl "full log file name.asc"


use strict;
use warnings;

if(!$#ARGV)
{
    my $infile = $ARGV[0];
    my $outfile = "intermediate.log";
    my $directory = "Message_Logs/".$infile;
    my @list = ();
    my $line = "";
    
    open INFILE,"<",$infile or die "Cannot open ".$infile;
    mkdir $directory;
    
    while(<INFILE>)
    {
        if(m/\s*(\w+)\.(\w+)\s*\w\s*(\w+).+d\s*\w(.+)/)
        {
            $line = $3." ".$1.".".$2." ".$4."\n";
        }
        push @list, $line;
    }
    close INFILE;
    @list = sort @list;
    
    open OUTFILE,">",$outfile or die "Cannot open ".$outfile;
    foreach(@list)
    {
        print OUTFILE $_;
    }
    close OUTFILE;
    
    open OUTFILE,"<",$outfile or die "Cannot open ".$outfile;
    chdir($directory);
    my $curr_file = "";
    my $prev_file = "";
    my @data = ();
    my $messagecount = 0;
    
    while(my $line = <OUTFILE>)
    {
        $line =~ m/\s*(\w+)\s*(.+)/;
        $curr_file = $1;
        if($curr_file ne $prev_file)
        {
            @data = sort @data;
            foreach(@data)
            {
                print LOGFILE $_."\n";
            }
            close LOGFILE if $prev_file;
            $messagecount++;
            @data = ();
            open LOGFILE,">",$curr_file.".log" or die "Cannot create ".$curr_file;
        }
        push @data, $2;
        $prev_file = $curr_file;
    }
    @data = sort @data;
    foreach(@data)
    {
        print LOGFILE $_."\n";
    }
    close LOGFILE;
    print "Message data parsed successfully in ".$messagecount." message files at /".$directory." !\n";
    close OUTFILE;
}
else
{
    print "Incorrect number of arguments entered : ".($#ARGV+1)."\n";
    print "Correct usage : perl extractor.pl \"log file name.asc\"";
}
