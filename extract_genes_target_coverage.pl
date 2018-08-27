#!/usr/bin/perl -w
use strict;

die "\nUsage: perl $0 <in_genes> <in.Regions.interval_list> <out>\n\n" if (@ARGV != 3);

my %genes;
open (GENES, "<$ARGV[0]") or die "Cannot open the input genes file.\n";
while (<GENES>) {
        my $gene = $_;
        chomp($gene);
        $gene =~ s/\r//g;
        $gene =~ s/\n//g;
        $genes{$gene} = $gene;
}
close GENES;


my %target;
my ($chr, $start, $end, $symbol, $target_number);
my $counter = 0;   #Target number counter
open (REGIONS, "<$ARGV[1]") or die "Cannot open the input Regions.bed file!\n";
while(<REGIONS>) {	if($_=~/^chr/){
	$counter++;
	my $line=$_;
	chomp($line);
	$line =~ s/\r//g;
	$line =~ s/\n//g;

	my @elements = split("\t", $line);
	($chr, $start, $end, $symbol) = ($elements[0], $elements[1], $elements[2], $elements[4]);
	$target_number = 'target' . $counter;
	if(exists $genes{$symbol}) {
		$target{$target_number} = $chr . "\t" . $start . "\t" . $end;
	}}
}
close REGIONS;


open (OUT, ">$ARGV[2]") or die "Cannot open the output file: $ARGV[2]!\n";

my $inputfolder = "";   #input folder; need to be modified
opendir (DH, $inputfolder) or die "Cannot open the input overall data folder: $inputfolder!\n";
my @files = readdir(DH);

my $file_counter = 0;
while ($file_counter <= $#files) {
	if ($files[$file_counter] =~ /(^21\d+.+L999$)/){   #sample name pattern; need to be modified
		my $sample_folder = $1;
		my $subfolder = "$inputfolder/$sample_folder";
		opendir (SDH, $subfolder) or die "Cannot open the input sample data folder: $subfolder!\n";
			my @sample_files = readdir(SDH);
			foreach my $search_file (@sample_files) {
				if ($search_file =~ /(^21\d+.+picard_stats_per_target.txt$)/) {   #sample per target coverage; need to be modified
						my $per_target = $1;
						my $per_target_path = "$subfolder/$per_target";

						print OUT $per_target;

						open (PER_TARGET, $per_target_path) or die "Cannot open the per target coverage file: $per_target_path!\n";
							foreach my $search_target (keys %target) {
								my $search_target_coverage = `grep -P \"\\b$search_target\\b\" $per_target_path | cut -f7`; $search_target_coverage =~ s/\r//g; $search_target_coverage =~ s/\n//g;
								print OUT "\t" . $search_target . "\t" . $search_target_coverage;
							}

						print OUT "\n";

						close PER_TARGET;
				}   #if ($search_file =~ /(^21\d+.+picard_stats_per_target.txt$)/)
			}   #foreach my $search_file (@sample_files)
		close SDH;
	}   #if ($files[$file_counter] =~ /(^21\d+.+L999$)/)
	$file_counter++;
}   #while ($file_counter <= $#files)


close OUT;
closedir DH;
