#!/usr/bin/env perl

# Select otf and ttf fonts that contain Lating and Cyrillic code points
# Usage "echo font.otf | ./selectfonts [-d]
# -d - debug on
use strict;
use Getopt::Std;
our($opt_d);
getopts('d');
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
if ($opt_d) {
    print STDERR  join(", ", map(chr, @requiredChars)), "\n";
}
# loop over fonts
while (<>) {
    chomp;
    if ($opt_d) {
	print STDERR "Woring with font $_\n";
    }
    my $fontfile = `kpsewhich $_`;
    chomp $fontfile;
    if ($opt_d) {
	print STDERR "Font file $fontfile\n";
    }
    my $ranges=`fc-query -f '%{charset}' $fontfile`;
    if ($opt_d) {
	print STDERR "Ranges $ranges\n";
    }
}
