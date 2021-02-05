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

setup(
	name = "tarsplit",
	version = "1.0",
	description = "Split tarballs into smaller pieces along file boundaries.",
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


