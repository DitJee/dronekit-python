#!/usr/bin/env python

"""
This script gets the release notes, converts it from markdown to
reStructured Text format, and writes it to a text file.

The text file can be auto-imported by Sphinx into the official release notes.
"""

import os
from pypandoc import convert
from optparse import OptionParser
import re

curpath = os.path.realpath(os.path.dirname(__file__))

#parser options
parser = OptionParser(version="%prog 1.0.0", usage="Usage: %prog [options] version")
parser.add_option("-i" , "--input", dest="input", default=os.path.join(curpath, "../CHANGELOG.md"), help="Input file")
parser.add_option("-f" , "--file", dest="file", default=os.path.join(curpath, "../docs/about/github_latest_release.txt"), help="Output file")

(options, args) = parser.parse_args()

rst_content = convert(options.input, 'rst')

# Hyperlink Github issues
rst_content = re.sub(r'#\d+', lambda m: '`' + m.group() + ' <https://github.com/dronekit/dronekit-python/pulls/' + m.group()[:-1] + '>`_', rst_content)

# Prefix with some documentation
rst_content = ".. This document was auto-generated by the get_release_notes.py script using latest-release information from github \n\n" + rst_content

release_notes_file = open(options.file,'w')
release_notes_file.write(rst_content)
release_notes_file.close()

print 'complete.' 

