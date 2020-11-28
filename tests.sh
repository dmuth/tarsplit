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

# Did any of the tests fail?
FAILED=""

#
# ANSI codes for printing out different colors.
#
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"

function pass() {
        printf "[ ${GREEN}PASS${NC} ] "
}

function fail() {
        printf "[ ${RED}FAIL${NC} ] "
}

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
	#${BIN}/sha1-from-directory.sh tarball-root-dir # Debugging
	SHA1_CHECK=$(${BIN}/sha1-from-directory.sh tarball-root-dir)

	if test $SHA1 == $SHA1_CHECK
	then
		pass
		echo "($SHA1 == $SHA1_CHECK)"
	else
		FAILED=1
		fail
		echo "($SHA1 != $SHA1_CHECK)"
		#exit 1
	fi

	# Leave the directory and cleanup
	popd > /dev/null
	rm -rf ${TMP}

} # End of split_and_test()


#
# Create our test tarball and get the SHA1
#
${BIN}/create-test-tarball.sh
SHA1=$(${BIN}/sha1-from-tarball.sh ${TARBALL})
echo "##### Our SHA1 to match against: ${SHA1} #####"


#
# Run our tests
#
split_and_test 2
split_and_test 3
split_and_test 4
split_and_test 5
split_and_test 10

if test "${FAILED}"
then
	fail
	echo "One or more tests failed!"
	exit 1

else
	pass
	echo "OK: All tests passed!"
fi


