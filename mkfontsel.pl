#!/usr/bin/env perl
use strict;
open(FONTS, "selectedfonts");
my $i=1;
while(<FONTS>) {
    chomp;
    if (/^.*#/) {
	next;
    }
    my ($font, $feature) = split;
    open(RES, ">fontsel/$i.tex");
    if (length($feature)) {
	print RES "\\setfontface{\\SILmfont}{$font}[RawFeature=+$feature]\n";
    } else {
	print RES "\\setfontface{\\SILmfont}{$font}\n";
    }
    print RES "\\def\\SILmfontname{$_}\n";
    close RES;
    $i++;    	       
}
$i--;
open(RES, ">pickfont.tex");
print RES "\\setcounter{SIL\@maxfont}{$i}\n";
    
     

