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
for FILE in $(find * -type f | sort)
do
	#sha1sum $FILE # Debugging
	sha1sum $FILE | awk '{ print $1 }' >> $RESULTS
done

#
# Now go through our symlinks and if it is a valid symlink, SHA1 the contents,
# otherwise SHA1 the filename.
#
# FUN FACT: If I run find with "*" instead of "." as the path, I won't get all
# of those leading "./" characters.  I'll miss hidden files, but that should be 
# acceptable for the intended use of this script.
#
for FILE in $(find * -type l | sort )
do
	if test -e $FILE
	then
		#sha1sum $FILE # Debugging
		sha1sum $FILE | awk '{ print $1 }' >> $RESULTS
	else
		#echo "Broken symlink: $FILE" # Debugging
		#echo $FILE | sha1sum # Debugging
		echo $FILE | sha1sum | awk '{ print $1 }' >> $RESULTS
	fi
done

#cat $RESULTS # Debugging
sha1sum $RESULTS | awk '{ print $1 }'

# Cleanup
rm -rf ${TMP} ${RESULTS}


