#!/bin/bash
#
# This script create our initial tarball
#

# Errors are fatal
set -e

NUM_FILES_AND_DIRS=5
#NUM_FILES_AND_DIRS=2 # Testing/Debugging

# Our root directory for the tarball
DIR="tarball-root-dir"

# Our test tarball
TARBALL="test-tarball.tgz"

TMP=$(mktemp -d)
START_DIR=$(pwd)

#
# Do all work in our temp directory.
#
pushd ${TMP} > /dev/null

#
# Create a series of directories with files and directories under them.
#
echo "# Creating test directory: ${DIR}"
for I in $(seq ${NUM_FILES_AND_DIRS})
do
	mkdir -p ${DIR}/${I}

	#
	# Make a file in this directory.
	#
	TARGET="${DIR}/file-${I}.data"
	if test ! -f "${TARGET}"
	then
		dd if=/dev/zero of="${TARGET}" bs=1m count=1 2> /dev/null
	fi

	#
	# Make our files in each sub-directory
	#
	for J in $(seq ${NUM_FILES_AND_DIRS})
	do
		mkdir -p ${DIR}/${I}/${J}
		
		TARGET="${DIR}/${I}/file-${J}.data"
		if test ! -f "${TARGET}"
		then
			dd if=/dev/zero of="${TARGET}" bs=1m count=1 2> /dev/null
		fi
	done

	#
	# Make a symlink to the previous number.
	# I am aware that this will result in the first symlink being broken, and
	# that is intentional, as I want broken symlinks to created/tested.
	#
	if test "$I" -gt 1
	then
		SOURCE="${DIR}/${I}/file-${I}.link"
		TARGET="../file-$(( I - 1 )).data" 

		ln -sf ${TARGET} ${SOURCE} 
	fi

done

#
# Create our test tarball, move it to our starting directory, and remove our temp directory
#
echo "# Creating test tarball: ${TARBALL}"
rm -fv ${TARBALL} > /dev/null
tar cfz ${TARBALL} ${DIR}
mv ${TARBALL} ${START_DIR}
rm -rf ${TMP}

echo "# Done! (Directory ${DIR} has since been removed...)"

