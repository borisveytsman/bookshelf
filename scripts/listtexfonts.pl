#!/usr/bin/env perl
#
# List the fonts known to TeX
#
=pod

=head1 NAME

listtexfonts.pl - list all TTF and OTF fonts known to TeX

=head1 SYNOPSIS

B<listtexfonts.pl> [PATTERN PATTERN ...]

B<listtexfonts.pl> -v

B<listtexfonts.pl> -h

=head1 DESCRIPTION

List all TTF and OTF files known to TeX system.  If no arguments are given, search all ls-R files.  Otherwise search only the directories following the PATTERN (in regexep sense).  For example,

    listtexfonts.pl '.*texmf-dist.*'

gives only the fonts in the C<texmf-dist> distribution.

Outputs the locations of ttf or otf files, one per line

=head1 OPTIONS

=over 4

=item B<-v>

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
our $VERSION="Version 1.0.\n";
our $USAGE=<<END;
Usage: $0 [PATTERN PATTERN...].
$VERSION
List the locations of all TTF or OTF files known to TeX, one per line
If PATTERNs are given, include only the files in the directories
satisfying PATTERN (in regexp sense, so '.*texmf-dist.*' is
a good pattern).
END
use Getopt::Std;
use vars qw($opt_v $opt_h);
getopts('hv') or die $USAGE;
if ($opt_v) {
    die $VERSION;
}
if ($opt_h) {
    die $USAGE;
}
my @patterns;
foreach (@ARGV) {
    push @patterns, $_;
}


my $lsR = GetLsRFiles(\@patterns);

foreach my $filename (@{$lsR}) {
    ProcessLsRFile($filename);
}






sub GetLsRFiles {
    my $patterns=shift;
    my @lsR;
    open(LSRS,"kpsewhich -all ls-R|");
    while (<LSRS>) {
	chomp;
	my $found=0;
	if (!scalar(@{$patterns})) {
	    $found=1;
	}
	for my $pattern (@{$patterns}) {
	    if (/$pattern/) {
		$found=1;
		last;
	    }	
	}
	if ($found) {
	    push @lsR, $_;
	}
    }
    close LSRS;
    return \@lsR;
}



sub ProcessLsRFile {
    my $filename=shift;
    my $base=$filename;
    $base =~ s|/ls-R||;
    open (LSR, "$filename") or die "Cannot find $filename\n";
    my $dirname=$base;
    while (<LSR>) {
	chomp;
	if ($_ =~ s/^\.(.*):$/$1/) {
	    $dirname = "$base$_";
	    next;
	}
	if (/\.[ot]tf$/i) {
	    print "$dirname/$_\n";
	}
    }
    close LSR;
}
