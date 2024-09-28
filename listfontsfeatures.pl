#!/usr/bin/env perl

# Get font features of the given otf or ttf font.  List them
# on STDOUT

use strict;
use Getopt::Std;
use open qw( :std :encoding(UTF-8) );
our(%opts);

my $USAGE="$0 [-d] [-p PATTERN_FILE] [-x FORBIDDEN_PATTERNS] otf_file...\n";
getopts('dp:x:', \%opts) or die $USAGE;
    
my $DEBUG=0;
if (exists($opts{'d'})) {
    $DEBUG=1;
}

my @patterns;
if (-r $opts{p}) {
    open(PATTERNS, $opts{p}) or die ("Cannot open $opts{p}");
    while (<PATTERNS>) {
	chomp;
	if (length($_)) {
	    push @patterns, $_;
	}
    }
    close PATTERNS;
} else {
    @patterns = ('^cc*', '^ss*');
}

my @excluded;
if (-r $opts{x}) {
    open(PATTERNS, $opts{x}) or die ("Cannot open $opts{p}");
    while (<PATTERNS>) {
	chomp;
	if (length($_)) {
	    push @excluded, $_;
	}
    }
    close PATTERNS;
}

my $standardFeatures="+clig;+liga;+tlig";

while(<>) {
    chomp;
    my $font=$_;
    my $fontfile = `kpsewhich $font`;
    chomp $fontfile;
    if (!length($fontfile)) {
	if ($DEBUG) {
	    print STDERR "Font $font is not found\n";
	}
	next;
    }
    if ($DEBUG) {
	print STDERR "Font file $fontfile\n";
    }
    my $goodFont=1;
    foreach my $excl (@excluded) {
	if ($font =~ m/$excl/) {
	    $goodFont=0;
	    if ($DEBUG) {
		print STDERR "Font $font is excluded by pattern $excl\n";
	    }
	    last;
	}
    }
    if ($goodFont) {
	print "$font:$standardFeatures\n";
	open (FEATURES, "otfinfo -f $fontfile |");
	while (<FEATURES>) {
	    chomp;
	    my ($feature,@tmp)=split;
	    my $goodFeature=0;
	    foreach my $pattern (@patterns) {
		if ($feature =~ m/$pattern/) {
		    $goodFeature=1;
		    last;
		}
	    }
	    if (!$goodFeature) {
		next;
	    }
	    my $output="$font:$standardFeatures;+$feature";
	    foreach my $excl (@excluded) {
		if ($output =~ m/$excl/) {
		    $goodFeature=0;
		    if ($DEBUG) {
			print STDERR
			    "Combination $output is excluded by pattern $excl\n";
		    }
		    last;
		}
	    }
	    if ($goodFeature) {
		print "$output\n"
	    }

	}
	close FEATURES;
    }
    
}
