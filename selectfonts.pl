#!/usr/bin/env perl

# Select otf and ttf fonts that contain Lating and Cyrillic code points
# Usage "echo font.otf | ./selectfonts [-d]
# -d - debug on
use strict;
use Getopt::Std;
use open qw( :std :encoding(UTF-8) );
our($opt_d);
getopts('d');
my $debug=$opt_d;
my @requiredChars;
# Basic latin
push @requiredChars, 0x0021..0x007E;
# Yo, Ye
push @requiredChars, 0x0401, 0x0404;
# Ye
#push @requiredChars, 0x0404;
# Cyrillic
push @requiredChars, 0x0410..0x044F;
# yo, ye
push @requiredChars, 0x0451, 0x0454;
# ye
# push @requiredChars, 0x0454;
# Ghe, ghe
push @requiredChars, 0x0490, 0x0491;
# interesting otf features.  These are regex patterns
my @features=('^hist$', '^onum$', '^pcap$', '^smcp$',
	      '^ss', '^swsh$', '^titl$');
if ($debug) {
    print STDERR  "Required charecters: ",
	join(", ", map(chr, @requiredChars)), "\n";
}
if ($debug) {
    print STDERR  "OTF features: ",
	join(", ", @features), "\n";
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
	OutputFont($font, \@features, $debug);
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
	push @ranges, [ hex($min), hex($max) ];	
    }
    return @ranges;
}

sub OutputFont {
    my ($font, $features, $debug) = @_;
    if ($debug) {
	print STDERR "Font with defaults: $font\n";
    }
    print "$font\n";
    my $fontfile = `kpsewhich $font`;
    chomp $fontfile;
    open (FEATURES, "otfinfo -f $fontfile |");
    while (<FEATURES>) {
	my ($feature,@tmp)=split;
	# A bug in Alegreya ss02
	if ($font =~ m/^Alegreya/ && $feature eq 'ss02') {
	    if ($debug) {
		print STDERR "Skipping $font $feature\n";
	    }
	    next;
	}
	# A bug in Spectral ss04
	if ($font =~ m/^Spectral/ && $feature eq 'ss04') {
	    if ($debug) {
		print STDERR "Skipping $font $feature\n";
	    }
	    next;
	}
	foreach my $pattern (@{$features}) {
	    if ($feature =~ m/$pattern/) {
		if ($debug) {
		    print STDERR "Adding +$feature\n";
		}
		print "$font $feature\n";
	    }
	}
    }
    close (FEATURES);
}
