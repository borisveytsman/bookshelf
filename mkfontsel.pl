#!/usr/bin/env perl
#
# Usage ./mkfontsel FILE
#
use strict;
`mkdir -p fontsel`;
my $file = shift;    
open(FONTS, $file);
my $i=1;
while(<FONTS>) {
    chomp;
    if (/^.*#/) {
	next;
    }
    open(RES, ">fontsel/$i.tex");
    print RES "\\font\\SILmfont={$_}\\SILmfont\n";
    print RES "\\def\\SILmfontname{$_}%\n";
    close RES;
    $i++;    	       
}
$i--;
open(RES, ">pickfont.tex");
print RES "\\setcounter{SIL\@maxfont}{$i}\n";
    
     

