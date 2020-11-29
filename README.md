<img src="./img/tarsplit.png" width="300" align="right" />

# Tarsplit
A utility to split tarballs into smaller pieces along file boundaries.


## Installation

- `curl https://raw.githubusercontent.com/dmuth/tarsplit/main/tarsplit > /usr/local/bin/tarsplit && chmod 755 /usr/local/bin/tarsplit`


## Usage

`tarsplit [ --dry-run ] tarball num_files`

Example run:
```
$ ./tarsplit ./test-tarball.tgz 3
Welcome to Tarsplit! Reading file ./test-tarball.tgz...
Total uncompressed file size: 31457280 bytes, num chunks: 3, chunk size: 10485760 bytes
10 files written to test-tarball.tgz-part-1-of-3
20 files written to test-tarball.tgz-part-1-of-3
Successfully wrote 10485760 bytes in 22 files to test-tarball.tgz-part-1-of-3
10 files written to test-tarball.tgz-part-2-of-3
20 files written to test-tarball.tgz-part-2-of-3
Successfully wrote 10485760 bytes in 22 files to test-tarball.tgz-part-2-of-3
10 files written to test-tarball.tgz-part-3-of-3
20 files written to test-tarball.tgz-part-3-of-3
Successfully wrote 10485760 bytes in 21 files to test-tarball.tgz-part-3-of-3
```


## FAQ

### How does work?

This script is written in Python, and uses the <a href="https://docs.python.org/3/library/tarfile.html">tarfile module</a> 
to read and write tarfiles.  This has the advantage of not having to extract the entire tarball,
unlike the previous version of this app which was written in Bash Shell Script.


### Why?

While working on <a href="https://github.com/dmuth/splunk-lab">Splunk Lab</a>, I kept running into
an issue where a particular layer in the Docker image was a Gigabyte in size.  This was a challenge because
there was a number of wallclock seconds wasted when processing the large layer after a push or pull.  
If only there was a way to split that layer up into multiple smaller layers, which Docker would then 
transfer in parallel...

While investigating, the culprit turned out to be a very large tarball.  I wanted a way to split that
tarball into multiple smaller tarballs, each of which contained a portion of the filesystem.  Then, I could
build multiple Docker containers, each with a portion of the original tarball's files, with each container
inheriting the previous container.  This would leverage the things Docker is good at: layered filesystems.


## Development

### Support scripts

- `bin/create-test-tarball.sh` - Create a test tarball with directories and files inside.
- `sha1-from-directory.sh` - Get a recursive list of all files in a directory, sort it, SHA1 each file, then concatenate all SHA1s and SHA1 that!
- `sha1-from-tarball.sh` - Extract a tarball, then do the same thing to the contents as `sha1-from-directory.sh`.


### Tests

Tests can be run with `tests.sh`.  A successful run looks something like this:

<img src="./img/tests.png" />


## TODO

- Make available in Homebrew


