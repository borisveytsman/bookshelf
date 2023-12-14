#!/usr/bin/env bash
grep ^@ books.bib | sed 's/@.*{ /\\makebook{/' | sed 's/,/}%/'
