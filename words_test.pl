#!/usr/bin/perl -w

# Title: words_test.pl
# Desc: https://gist.github.com/seanthehead/11180933
# Author: Chris Hart
# Date: 2015.04.29

use strict;
use Getopt::Long;

my ($debug, $file, $help);
my (%global_matches, %sequence_map);
my @dictionary;

my $sequences_file = './sequences';
my $words_file = './words';

GetOptions (
	'debug!'	=> \$debug,
	'f=s'		=> \$file,
	'help!'		=> \$help,
);

&usage() if ( $help );

if ($file) {
    open(FILE, "<", $file);
        @dictionary = <FILE>;
    close(FILE);
}

# Print Usage and Die if we don't have a Dictionary
&usage() unless ( @dictionary );

foreach my $term ( @dictionary ) {
	chomp $term;
	my $max_offset = ( length $term ) - 3;
	my @matches;

	# iterate over the term 
	for ( my $i = 0; $i < $max_offset; $i++ ) {
		my $term_part = substr $term, $i, $i + 4;

		# Match *letters* not word characters
		my @m = $term_part =~ m/([[:alpha:]]{4})/cg;
		push( @matches, @m );
	}

	# Count the sequence matches and store the associated dictionary terms
	foreach my $m ( @matches ) {
		$global_matches{ $m } = 0 unless ( $global_matches{ $m } );
		$global_matches{ $m }++;
		$sequence_map{ $m } = $term;
	}
}

unless ( $debug ) {
	open ( SEQ_FILE, ">", $sequences_file ) or die "Could not open sequences file $sequences_file!\n";
	open ( WRD_FILE, ">", $words_file ) or die "Could not open words file $words_file!\n";
}

foreach my $seq ( sort keys %sequence_map ) {
	my $word = $sequence_map{ $seq };

	# Skip non-unique sequences
	next unless ( $global_matches{ $seq } == 1 );

	unless ( $debug ) {
		# Output to open filehandles
		print SEQ_FILE $seq . "\n";
		print WRD_FILE $word . "\n";
	} else {
		print $seq . "\t" . $word . "\n";
	}
}

unless ( $debug ) {
	close ( SEQ_FILE );
	close ( WRD_FILE );
}

sub usage {
	die "Usage: $0 [OPTIONS]

    Given a dictionary file -f, generates two output files, 'sequences' and 'words'.
    'sequences' will contain every sequence of four letters that appears in exactly one word of the dictionary, one sequence per line.
    'words' will contain the corresponding words that contain the sequences, in the same order, again one per line.

    [OPTIONS]
    -f [FILE]	Path to dictionary FILE

    -debug	Print tab delimited sequences and words to STDOUT rather than the output files
    -help	This Usage Menu.
	\n";
}

