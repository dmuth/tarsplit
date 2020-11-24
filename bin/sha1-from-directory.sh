#!/bin/bash
#
# This script will take a directory, get SHA1 results for all files, and then
# sort the results and create a SHA1 for that listing.
#
# The goal is to get a SHA1 of the contents of a tarball (or multiple tarballs)
#

# Errors are fatal
set -e

RESULTS=$(mktemp)

#
# Print our syntax and exit with an error.
#
function print_syntax() {
	echo "! "
	echo "! Syntax: $0 directory"
	echo "! "
	echo "! Create a SHA1 for the contents of all files in the specified directory."
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

DIR=$1

#
# Do all work in our directory so the name of the directory and and possible
# case issues (looking at you, OS/X) do not potentially interfere
#
pushd ${DIR} > /dev/null

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


