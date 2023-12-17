#!/usr/bin/env bash
grep ^@ books.bib | sed '/^@preamble/d' | sed 's/@.*{ /\\makebook{/' | sed 's/,/}%/'
