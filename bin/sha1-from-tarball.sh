#!/bin/bash
#
# This script will untar a file to a temp directory, get SHA1 results for all files, and then
# sort the results and create a SHA1 for that listing.
#
# The goal is to get a SHA1 of the contents of a tarball (or multiple tarballs)
#

# Errors are fatal
set -e

DIR=$(pwd)
TMP=$(mktemp -d)
RESULTS=$(mktemp)

#
# Print our syntax and exit with an error.
#
function print_syntax() {
	echo "! "
	echo "! Syntax: $0 tarball [ tarball [ ... ] ]"
	echo "! "
	echo "! Extract all tarballs into one directory and create a SHA1 for the contents."
	echo "! "
	exit 1
} 


if test ! "$1" 
then
	print_syntax
fi

if test "$1" == "-h" -o "$1" == "--help"
then
	print_syntax
fi


#
# Change to our directory and extract everything there.
#
pushd $TMP > /dev/null

for FILE in $@
do
	tar xfz ${DIR}/${FILE} 
done

#
# Sort our entire directory tree, calculate the SHA1 for each file, and 
# add the result to our results file.
#
for FILE in $(find . -type f | sort)
do
	sha1sum $FILE | awk '{ print $1 }' >> $RESULTS
done

#cat $RESULTS # Debugging
sha1sum $RESULTS | awk '{ print $1 }'

# Cleanup
rm -rf ${TMP} ${RESULTS}


