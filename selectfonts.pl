#!/usr/bin/env perl

# Select otf and ttf fonts that contain Lating and Cyrillic code points
# Usage "echo font.otf | ./selectfonts [-d]
# -d - debug on
use strict;
use Getopt::Std;
our($opt_d);
getopts('d');
my $debug=$opt_d;
my @requiredChars;
# Basic latin
push @requiredChars, 0x0021..0x007E;
# Yo, Ye
push @requiredChars, 0x0401, 0x0404;
# Cyrillic
push @requiredChars, 0x0410..0x044F;
# yo, ye
push @requiredChars, 0x0451, 0x0454;
# Ghe, ghe
push @requiredChars, 0x0490, 0x0491;
if ($debug) {
    print STDERR  "Requrired charecters: ",
	join(", ", map(chr, @requiredChars)), "\n";
}
# loop over fonts
while (<>) {
    chomp;
    my $font=$_;
    if ($debug) {
	print STDERR "Working with font $font\n";
    }
    my @missingChars = GetMissingChars($font, \@requiredChars, $debug);
    if (!scalar(@missingChars)) {
	print($font, "\n");
    } else {
	if ($debug) {
	    print STDERR "Missing characters: ",
		join(", ", map(chr, @missingChars)), "\n";
	}
    }

}

sub GetMissingChars {
    my ($font, $required, $debug) = @_;
    my @ranges=GetRanges($font, $debug);
    my @missing;;
    foreach my $codepoint (@{$required}) {
	my $found=0;
	foreach my $range (@ranges) {
	    my $min=$range->[0];
	    my $max=$range->[1];
	    if ($codepoint < $min) {
		last;
	    }
	    if ($codepoint > $max) {
		next;
	    }
	    $found=1;
	    last;
	}
	if (!$found) {
	    push @missing, $codepoint;
	}
    }
    return(@missing);
}

sub GetRanges {
    my ($font, $debug) = @_;
    my @ranges;
    my $fontfile = `kpsewhich $font`;
    chomp $fontfile;
    if (!length($fontfile)) {
	if ($debug) {
	    print STDERR "Font $font is not found\n";
	}
	return(@ranges)
    }
    if ($debug) {
	print STDERR "Font file $fontfile\n";
    }
    my $rangesStr=`fc-query -f '%{charset}' $fontfile`;
    foreach my $range (split /\s+/, $rangesStr) {
	my ($min, $max) = split /-/, $range;
	if ($max eq '') {
	    $max=$min;
	}
	push @ranges, [ int("0x".$min), int("0x".$max) ];	
    }
    return @ranges;
}
