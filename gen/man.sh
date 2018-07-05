#!/bin/sh
# Generates `lf.1` man page using man macros with `go doc` output.
#
# This script is called in `doc.go` using `go generate` to generate a man page
# formatted with man macros from the documentation. A few additional sections
# such as `NAME` and `SYNOPSIS` are added to comply with man page conventions.
#
# Conversion logic implemented here from godoc output to man macros should not
# be considered compliant, as such it has inexact assumptions such as the use
# of spaces over tabs along with various corner cases that are not handled
# properly like character escaping. The intention here is to come up with
# something that can convert the current content in the documentation. For this
# reason, it is recommended to check the output after generation especially
# when the documentation is changed in a significant way.

out=lf.1

echo '.\" Code generated by gen/man.sh DO NOT EDIT.' > $out

cat << END >> $out
.TH LF 1
.SH NAME
lf \- terminal file manager
.SH SYNOPSIS
.SY lf
.OP \-cpuprofile path
.OP \-doc
.OP \-last-dir-path path
.OP \-memprofile path
.OP \-remote command
.OP \-selection-path path
.OP \-server
.OP \-version
.RI [ directory ]
.YS
.SH DESCRIPTION
END

go doc | awk '
BEGIN {
    RS = ""
    start = 1
}

# preformatted
/^ / {
    gsub("\\\\", "\\e", $0)
    print ".PP"
    print ".EX"
    print $0
    print ".EE"
    next
}

# heading
/^[^[:punct:]]*$/ {
    print ".SH", toupper($0)
    start = 1
    next
}

# paragraph
{
    gsub("\n", " ", $0)
    gsub("\\\\", "\\e", $0)
    if (start) { start = 0 } else { print ".PP" }
    print $0
}
' >> $out
