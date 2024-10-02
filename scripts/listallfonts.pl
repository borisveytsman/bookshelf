#!/usr/bin/env perl
#
=pod

=head1 NAME

listallfonts.pl - list all fonts known to LuaTeX with "interesting" features

=head1 SYNOPSIS

listallfonts.pl [-d] [-f FEATURES_FILE] [-x EXCLUDED_PATTERNS_FILE]

listallfonts.pl -h

listallfonts.pl -v

=head1 DESCRIPTION

List all fonts known to LuaTeX adding "interesting" features to the
listing.

The script queries luaotfload databases and outputs the list of fonts
and features as a tab-separated stream with two field: font
name+feature name, and LuaTeX loading command.  This form is suitable
for L<mkfontsel.pl(1)> command from the I<bookshelf> package.

We always include default features, C<+clig;+liga;+tlig>.

It is recommended to issue

    luaotfload-tool --update --force

before running the script.

=head1 OPTIONS

=over 4

=item B<-d>

Print debug information on the standard output.

=item B<-f> I<FEATURES_FILE>

Use patterns in the I<FEATURES> file instead of the default ones.

=item B<-x> I<EXCLUDED_PATTERNS_FILE>

Exclude patterns (font paths and features or combinations) listed
in I<EXCLUDED_PATTERNS_FILE>.

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
use Getopt::Std;
use open qw( :std :encoding(UTF-8) );
my $VERSION = "1.0";
my $USAGE="$0 [-d] [-f FEATURES_FILE] [-x EXCLUDED_PATTERNS_FILE]";
our(%opts);

getopts('df:x:vh', \%opts) or die "$USAGE\n";

if (exists($opts{h})) {
    die "$USAGE\n";
}
if (exists($opts{v})) {
    die "$0, Version $VERSION, MIT License\n";
}

my $DEBUG=0;
if (exists($opts{'d'})) {
    $DEBUG=1;
}

my @features;
if (exists $opts{f}) {
    open(FEATURES, $opts{f}) or die ("Cannot open $opts{f}");
    while (<FEATURES>) {
	chomp;
	if (length($_)) {
	    push @features, $_;
	}
    }
    close FEATURES;
} else {
    @features = qw(
	^hist$
	^onum$
	^pcap$
	^smcp$
	^ss
	^swsh$
	^titl$
	^unic$
	);
}

my @excluded;
if (exists $opts{x}) {
    open(PATTERNS, $opts{x}) or die ("Cannot open $opts{x}");
    while (<PATTERNS>) {
	chomp;
	if (length($_)) {
	    push @excluded, $_;
	}
    }
    close PATTERNS;
} else {
    @excluded = qw(
	Alegreya.*\+ss02
	Spectral.*\+ss04
	Hans_Holbein
	Megazoid-Shade
	HEJI2Text
	NotoColorEmoji
	GimletXRay-VF
	MegabaseCore
	PappardelleV2
	countriesofeurope
	drmdoz
	drmsy
	drmtc
	drmfigs
	drmgrk
	smf
	SimpleIcons
	Skak
	FontAwesome
	InputCipher
	FdSymbol
	greciliae
	blex\.ttf
	blsy\.ttf
	rblmi\.ttf
	emo-lingchi
	MnSymbol
	MdSymbol
	dantelogo
	emmentaler
	marvosym
	Asap-Symbol
	metsymb
	AlgolRevived
	P22FraJenPeo.otf
	LTCFlueronsGranjon
	LTCArchiveOrn
	SVRsymbols
	LTCHalloweenOrnaments
	BradleyInitialsDJRLayers-Frame
	P22CezanSwa
	P22GaugnXtr
	P22CezanSkt
	P22CezanLig
	P22DeaPro.*\+ss07
	BradleyInitialsDJRLayers-Background
	Junicode.*\+ss12
	Junicode.*\+ss13
	Junicode.*\+ss14
	QTDingBits
	Math-Companion
	Script-Companion
	TwemojiMozilla
	NAMU-Tryzub
	\/Fonts\/Supplemental\/
	NotoSansMyanmar\.ttc
	);

my $standardFeatures="+clig;+liga;+tlig";

open(FONTS,
     'luaotfload-tool --list="plainname" --fields="fullpath,format,subfont"|')
    or die ("Cannot run luaotfload-tool\n");
while (<FONTS>) {
    chomp;
    if (/^\s*$/) {
	next;
    }
    my ($plainname, $fullpath, $format, $subfont) = split /\t/;
    if ($DEBUG) {
	print STDERR "Font: $plainname\n";
    }
    my $goodFont=1;
    foreach my $excl (@excluded) {
	if ($fullpath =~ m/$excl/) {
	    $goodFont=0;
	    if ($DEBUG) {
		print STDERR "  Font $plainname is excluded by pattern $excl\n";
	    }
	    last;
	}
    }
    if (!$goodFont) {
	next;
    }
    my $loadcommand = "[".$fullpath."]";
    if ($format eq 'ttc') {
	$loadcommand .= "(".($subfont-1).")";
    }
    $loadcommand .= ":$standardFeatures";
    print "$plainname\t$loadcommand\n";
    if ($format eq 'ttc') {
	next;  # WE do not extract features for TTC fonts
    }

    open (FEATURES, "otfinfo -f '$fullpath' |");
    while (<FEATURES>) {
	chomp;
	my ($feature, $featurename) = split /\t/;
	my $loadcommand1 = $loadcommand . ";+$feature";
	my $goodFeature=0;
	foreach my $pattern (@features) {
	    if ($feature =~ m/$pattern/) {
		$goodFeature=1;
		last;
	    }
	}
	if (!$goodFeature) {
	    next;
	}

	foreach my $excl (@excluded) {
	    if ($loadcommand1 =~ m/$excl/) {
	    $goodFeature=0;
	    if ($DEBUG) {
		print STDERR
		    "  Feature $featurename is excluded by pattern $excl\n";
	    }
	    last;
	    }

	}
	if ($goodFeature) {
	    print "$plainname; $featurename\t$loadcommand1\n";
	}
    }

    close FEATURES;

}
close FONTS;
