#!/usr/bin/env perl
#
# List the fonts system fonts
#
=pod

=head1 NAME

listsystemfonts.pl - list all TTF, OTF and TTC fonts known to the system

=head1 SYNOPSIS

B<listtexfonts.pl> [-s|-f]

B<listtexfonts.pl> -v

B<listtexfonts.pl> -h

=head1 DESCRIPTION

List all TTF, OTF and TTC files known to the system.  Output: one font per line, tab-separated file location and font name

=head1 OPTIONS

=over 4

=item B<-f>

Use C<fc> utilites.  The default on all systems but Mac

=item B<-s>

Use Mac C<system_profiler> utilities.  The default on Mac.

=item B<-v>

Print version information

=item B<-h>

Print usage information

=back

=head1 AUTHOR

Boris Veytsman, 2024, based on Peter Flynn's script published with C<bookshelf> package.

=head1 LICENSE

MIT license

=cut

use strict;
our $VERSION="Version 1.0.\n";
our $USAGE=<<END;
Usage: $0 [-f|-s]
$VERSION
List all TTF, OTF and TTC files known to the system.
Output: one font per line, tab-separated file location and font name
-f: use fc utilities (default on all systems but Mac)
-s: use Mac system profiler utilities (default on Mac)
END
use Getopt::Std;
use vars qw($opt_v $opt_h $opt_f $opt_s);
getopts('hvfs') or die $USAGE;
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

my $usefc=-1;
if ($opt_f) {
    $usefc=1;
} elsif ($opt_s) {
    $usefc=0;
}
if ($usefc<0) {
    if ($^O eq 'darwin') {
	$usefc=0;
    } else {
	$usefc=1;
    }
}


my $output={};

if ($usefc) {
    $output = ListFCFonts();
} else {
    $output = ListSysFonts();
}

if (scalar %{$output}) {
    foreach my $entry (sort keys %{$output}) {
	print "$entry\n";
    }
}


sub ListFCFonts {
    my %output;
    open (FC, "fc-list|");
    while (<FC>) {
	chomp;
	s/: /\t/;
	$output{$_}=1;
    }
    close FC;
    return \%output;
}

sub ListSysFonts {
    my %output;
    my $Location="";
    my $Name="";
    open (SP, "system_profiler SPFontsDataType|");
    while (<SP>) {
	chomp;
	if (s/^\s*Location: //) {
	    $Location=$_;
	    next;
	}
	if (s/^\s*Full Name: //) {
	    $Name .= "$_;";
	    next;
	}
	if (/^\s*$/ && length($Location)) {
	    $output{"$Location\t$Name"}=1;
	    $Location="";
	    $Name="";
	}
    }
    close SP;
    return \%output;
}
