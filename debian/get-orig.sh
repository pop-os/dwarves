#!/bin/sh
#
# We remove parts of dwarves which do not comply with the DFSG.
#
set -e

TMPDIR=`mktemp -t -d dwarves.XXXXXXXXXX`
trap "rm -Rf $TMPDIR" 0

VERSION=`head -1 debian/changelog | cut -d ' ' -f 2 | sed -e 's#(\([^-]\+\)-.*)#\1#'`
URL="http://userweb.kernel.org/~acme/dwarves"
DW="dwarves-$VERSION"

mkdir $TMPDIR/$DW

echo "retrieving dwarves version $VERSION"
(cd $TMPDIR/$DW && wget $URL/$DW.tar.bz2 2>/dev/null && tar xfj $DW.tar.bz2)

echo "removing grabbed tarball"
rm $TMPDIR/$DW/$DW.tar.bz2

echo "removing files that do not comply with the DFSG"
rm -Rf $TMPDIR/$DW/ostra

echo "generating ../dwarves-dfsg_$VERSION.orig.tar.gz"
tar -C $TMPDIR -czf ../dwarves-dfsg_$VERSION.orig.tar.gz $DW
