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
# Check the SHA1 from our tar parts versus the original SHA1
#
function check_sha1() {

	SHA1=$1

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

} # End of check_sha1()


#
# Split our tarball into a number of parts, extract those parts, and check SHA1 values.
#
function split_and_test() {

	SHA1=$1
	NUM_PARTS=$2

	TMP=$(mktemp -d)
	pushd ${TMP} > /dev/null

	echo "# Splitting our test tarball into ${NUM_PARTS} parts..."
	#${TARSPLIT} ${DIR}/${TARBALL} $NUM_PARTS # Debugging
	${TARSPLIT} ${DIR}/${TARBALL} $NUM_PARTS > /dev/null
	#ls -l # Debugging

	echo "# Extracting parts we just created and comparing SHA1..."
	for FILE in test-tarball.tgz-part-*
	do
		tar xfz ${FILE}
	done

	check_sha1 ${SHA1}

	# Leave the directory and cleanup
	popd > /dev/null
	rm -rf ${TMP}

} # End of split_and_test()


#
# Run the split_and_test() function against synthetic tarballs size n files/dirs.
#
function split_and_test_n() {

	N=$1

	#
	# Create our test tarball and get the SHA1
	#
	${BIN}/create-test-tarball.sh ${N}
	SHA1=$(${BIN}/sha1-from-tarball.sh ${TARBALL})
	echo "##### Our SHA1 to match against: ${SHA1} #####"

	#
	# Run our tests
	#
	for NUM_PARTS in 2 3 4 5 10
	do
		split_and_test ${SHA1} ${NUM_PARTS}
	done

} # End of split_and_test_n()


split_and_test_n 5
split_and_test_n 10
split_and_test_n 20 # This is a bit abusive in terms of time.


if test "${FAILED}"
then
	fail
	echo "One or more tests failed!"
	exit 1

else
	pass
	echo "OK: All tests passed!"
fi


