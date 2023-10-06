#!/usr/bin/env perl

# Select otf and ttf fonts that contain Lating and Cyrillic code points
# Usage "echo font.otf | ./selectfonts [-d]
# -d - debug on
use strict;
use Getopt::Std;
our($opt_d);
getopts('d');
my @requiredChars;

