#!/usr/bin/env python3
#
# Install the tarsplit package
#
#
# Development commands: 
#
#	pip install .; pip show -f tarsplit
#	pip uninstall tarsplit
#	python -m pip install git+https://github.com/dmuth/tarsplit.git
#

from distutils.core import setup
import setuptools
import pathlib

#
# Get the long description from the README file
#
here = pathlib.Path(__file__).parent.resolve()
long_description = (here / 'README.md').read_text(encoding='utf-8')

setup(
	name = "tarsplit",
 	# Version identifiers: https://www.python.org/dev/peps/pep-0440/#version-scheme
	version = "1.0.post04",
	description = "Split tarballs into smaller pieces along file boundaries.",
	long_description=long_description,
	long_description_content_type = "text/markdown",
	author = "Douglas Muth",
	author_email = "doug.muth@gmail.com",
	url = "https://github.com/dmuth/tarsplit",

	#
	# Full list at https://pypi.org/classifiers/
	#
	classifiers=[  # Optional
        	"Development Status :: 5 - Production/Stable",
        	"Intended Audience :: Developers",
        	"Topic :: Software Development :: Build Tools",
		"License :: OSI Approved :: Apache Software License",
        	"Programming Language :: Python :: 3",
	],

	install_requires = [ "humanize", "tqdm" ],

	project_urls = {
		"Source": "https://github.com/dmuth/tarsplit",
		"Tracker": "https://github.com/dmuth/tarsplit/issues",
		"Say Thanks!": "https://saythanks.io/to/doug.muth%40gmail.com",
	},

	scripts = ["tarsplit"],

     )


