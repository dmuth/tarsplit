#!/bin/bash
#
# This script create our initial tarball
#

# Errors are fatal
set -e

# Our root directory for the tarball
DIR="tarball-root-dir"

# Our test tarball
TARBALL="test-tarball.tgz"

#
# Create a series of directories with files and directories under them.
#
echo "# Creating test directory: ${DIR}"
for I in $(seq 5)
do
	mkdir -p ${DIR}/${I}

	TARGET="${DIR}/file-${I}.data"
	if test ! -f "${TARGET}"
	then
		dd if=/dev/zero of="${TARGET}" bs=1m count=1 2> /dev/null
	fi

	for J in $(seq 5)
	do
		mkdir -p ${DIR}/${I}/${J}
		
		TARGET="${DIR}/${I}/file-${J}.data"
		if test ! -f "${TARGET}"
		then
			dd if=/dev/zero of="${TARGET}" bs=1m count=1 2> /dev/null
		fi

	done

done

echo "# Creating test tarball: ${TARBALL}"
rm -fv ${TARBALL} > /dev/null
tar cfz ${TARBALL} ${DIR}
rm -rf ${DIR}

echo "# Done! (Directory ${DIR} has since been removed...)"

