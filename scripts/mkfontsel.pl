#!/usr/bin/env perl
#
#
=pod

=NAME

mkfontsel.pl FONTFILE

=DESCRIPTION

Create and populate fontsel directory from the file
produced by L<listallfonts.pl(1)> script, and create
C<pickfont.tex> file.  Used by
I<bookshelf> package.

=head1 OPTIONS

=over 4


Print version information

=item B<-h>

Print usage information

=back

=head1 AUTHOR

Boris Veytsman, 2024

=head1 LICENSE

MIT license

=cut


use strict;
use Getopt::Std;
use open qw( :std :encoding(UTF-8) );
my $VERSION = "1.0";
my $USAGE="$0 FILELIST";

our(%opts);

getopts('df:x:vh', \%opts) or die "$USAGE\n";

if (exists($opts{h})) {
    die "$USAGE\n";
}
if (exists($opts{v})) {
    die "$0, Version $VERSION, MIT License\n";
}


`mkdir -p fontsel`;
my $i=1;
while(<>) {
    chomp;
    if (/^.*#/) {
	next;
    }
    my ($name, $command) = split /\t/;
    open(RES, ">fontsel/$i.tex");
    print RES "\\font\\SILmfont={$command}\\SILmfont\n";
    print RES "\\def\\SILmfontname{$name}%\n";
    close RES;
    $i++;    	       
}
$i--;
open(RES, ">pickfont.tex");
print RES "\\setcounter{SIL\@maxfont}{$i}\n";
close RES;    
     

