#!/bin/bash
#
# Our main testing script.  This will create a test tarball, split it up a few ways,
# put the splitted files back together, and check that the SHA1s of all the files match.
#

# Errors are fatal
set -e

#
# Make a temp directory and hop right in there!
#
DIR=$(pwd)
BIN=${DIR}/bin
TMP=$(mktemp -d)
pushd ${TMP} > /dev/null

#
# Create our test tarball and get the SHA1
#
${BIN}/create-test-tarball.sh
SHA1=$(${BIN}/sha1-from-tarball.sh test-tarball.tgz)
echo "# Our SHA1 to match against: ${SHA1}"


# TODO:
# X Temp directory
# X Create test tarball
# X Get SHA1
# - Split tarball 2 ways
# - Write function to untar list of files
# - Get SHA1 from files and test
# - Split tarball 3, 4, 5, and 10 ways
# - Get SHA1 from files and test


# create-test-tarball.sh
# sha1-from-directory.sh

