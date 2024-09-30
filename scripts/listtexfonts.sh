#!/usr/bin/env bash

# List all TeX fonts in otf and ttf formats, optionally excluding patterns
# in the given file

addcommand="cat - "
while getopts "x:" OPTION; do
    case $OPTION in
	x)
	    addcommand="grep -v -f $OPTARG"
	    ;;
	*)
	    echo "Bad option"
	    exit 1
	    ;;
    esac
done
grep -h '\.\(otf\|ttf\)$' `kpsewhich -all ls-R` | $addcommand | sort -u
