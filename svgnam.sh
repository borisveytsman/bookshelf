#!/usr/bin/env bash

###########################################################
#
# Make a list of the colour selection from the SVG palette
# of the xcolor LaTeX package, with calculation of the
# brightness/darkness value according to
# https://www.nbdtech.com/Blog/archive/2008/04/27/Calculating-the-Perceived-Brightness-of-a-Color.aspx
#
# Usage: ./svgnam.sh > svgnam.tex
#
# Original author: Peter Flynn
#

cat <<EOF
%
% This is svgnam.tex file generated from svgnam.def by the script
% ./svgnam.sh > svgnam.tex
%
EOF

PALETTE=`kpsewhich svgnam.def`
cat $PALETTE |\
    grep '^[A-Z][A-Za-z]*,[\.0-9][0-9]*,[\.0-9][0-9]*,[\.0-9][0-9]*' |\
    awk -F\; '{print $1}' |\
    awk -F, '{r=$2;g=$3;b=$4} \
      {brightness=sqrt((0.241*r*r)+(0.691*g*g)+(0.068*b*b))} \
      {print $1,r,g,b,brightness}' >svgnam.csv
    cat svgnam.csv |\
    awk 'BEGIN {print "\\newcommand{\\SIL@svgcolname}[1]{\\ifcase#1 "} \
               {print $1 "\\or"} END {print "Black\\fi}\n"}' 
    cat svgnam.csv |\
    awk 'BEGIN {print "\\newcommand{\\SIL@svgcolval}[1]{\\ifcase#1 "} \
               {print $5 "\\or"} END {print "0\\fi}\n"}' 
    cat svgnam.csv | wc -l |\
    awk '{print "\\setcounter{SIL@maxcolno}{" $1 "}"}' 
