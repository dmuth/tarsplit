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
# Remove any trailing slashes from the directory name
#
DIR=$(echo $DIR | sed -e "s|/$||" )

#
# Remove ./ from the start of the path as that can also cause problems and is uncessary.
#
DIR=$(echo $DIR | sed -e "s|\./||" )


#
# Sort our entire directory tree, calculate the SHA1 for each file, and 
# add the result to our results file.
#
for FILE in $(find ${DIR} -type f | sort)
do
	#sha1sum $FILE # Debugging
	sha1sum $FILE | awk '{ print $1 }' >> $RESULTS
done

#
# Now go through our symlinks and if it is a valid symlink, SHA1 the contents,
# otherwise SHA1 the filename.
#
for FILE in $(find ${DIR} -type l | sort )
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


