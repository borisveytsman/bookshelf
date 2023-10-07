#!/usr/bin/env perl
use strict;
open(FONTS, "selectedfonts");
my $i=1;
while(<FONTS>) {
    chomp;
    if (/^.*#/) {
	next;
    }
    open(RES, ">fontsel/$i.tex");
    print RES "\\setfontface{\\SILmfont}{$_}\n";
    print RES "\\def\\SILmfontname{$_}\n";
    close RES;
    $i++;    	       
}
$i--;
open(RES, ">pickfont.tex");
print RES "\\setcounter{SIL\@maxfont}{$i}\n";
    
     

