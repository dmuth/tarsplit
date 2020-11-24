#!/bin/bash
#
# Our main testing script.  This will create a test tarball, split it up a few ways,
# put the splitted files back together, and check that the SHA1s of all the files match.
#

# Errors are fatal
set -e

TARBALL="test-tarball.tgz"

DIR=$(pwd)
BIN=${DIR}/bin
TARSPLIT=${DIR}/tarsplit

#
# Create our test tarball and get the SHA1
#
${BIN}/create-test-tarball.sh
SHA1=$(${BIN}/sha1-from-tarball.sh ${TARBALL})
echo "##### Our SHA1 to match against: ${SHA1} #####"


#
# Split our tarball into a number of parts, extract those parts, and check SHA1 values.
#
function split_and_test() {

	NUM_PARTS=$1

	TMP=$(mktemp -d)
	pushd ${TMP} > /dev/null

	echo "# Splitting our test tarball into ${NUM_PARTS} parts..."
	${TARSPLIT} ${DIR}/${TARBALL} $NUM_PARTS > /dev/null

	echo "# Extracting parts we just created..."
	for FILE in test-tarball.tgz-part-*
	do
		tar xfz ${FILE}
	done

	echo "# Getting our SHA1 from extracted files..."
	SHA1_CHECK=$(${BIN}/sha1-from-directory.sh tarball-root-dir)

	if test $SHA1 == $SHA1_CHECK
	then
		echo "# PASS! ($SHA1 == $SHA1_CHECK)"
	else
		echo "# FAIL! ($SHA1 != $SHA1_CHECK)"
		exit 1
	fi

	# Leave the directory and cleanup
	popd > /dev/null
	rm -rf ${TMP}

} # End of split_and_test()


#
# Run our tests
#
split_and_test 2
split_and_test 3
split_and_test 4
split_and_test 5
split_and_test 10

echo "OK: Done!"


