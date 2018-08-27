#!/usr/bin/perl -w
use strict;

die "\nUsage: perl $0 <in.Regions.interval_list> <in.rowtarget_colsample> <out>\n\n" if (@ARGV != 3);

my %target;
my ($chr, $start, $end, $symbol, $target_number);
my $counter = 0;   #Target number counter

open (REGIONS, "<$ARGV[0]") or die "Cannot open the input Regions.interval_list file!\n";
while(<REGIONS>) {	if($_=~/^chr/){
        $counter++;
        my $line=$_;
        chomp($line);
        $line =~ s/\r//g;
        $line =~ s/\n//g;

        my @elements = split("\t", $line);
        ($chr, $start, $end, $symbol) = ($elements[0], $elements[1], $elements[2], $elements[4]);
        $target_number = 'target' . $counter;

                $target{$target_number} = $chr . "\t" . $start . "\t" . $end . "\t" . $symbol;

}}
close REGIONS;

open (COV, "<$ARGV[1]") or die "Cannot open the input rowtarget_colsample file!\n";
open (OUT, ">$ARGV[2]") or die "Cannot open the output rowtarget_colsample add target details file!\n";
my $cov_line = 0;
while (<COV>) {
	$cov_line++;
	my $line = $_;
	$line =~ s/\n//g;
	$line =~ s/\r//g;
	if($cov_line == 1) {
		print OUT "chr\tstart\tend\tsymbol\t$line\n";
	}
	else {
		my @elements = split("\t", $line);
		my $current_target = $elements[0];
		print OUT $target{$current_target} . "\t" . $line . "\n";
	}
}
close COV;
close OUT;
