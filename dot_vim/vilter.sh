#!/bin/bash
TMPFILE=`mktemp /tmp/vipe.bashXXXXXXXX 2> /dev/null`
cat - > $TMPFILE
vim $TMPFILE "$@" > /dev/null < /dev/null 2> /dev/null
cat $TMPFILE
rm $TMPFILE
