#!/usr/bin/env bash

# List all TeX fonts in otf and ttf formats
grep -h '\.\(otf\|ttf\)$' `kpsewhich -all ls-R` | sort -u
