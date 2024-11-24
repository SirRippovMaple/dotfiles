#!/usr/bin/env python

"""
filter incoming lines based on date threshold
hides tasks marked with a date threshold ("t:YYYY-MM-DD") in the future
this is intended to be used as TODOTXT_FINAL_FILTER
"""

import sys
import re

from datetime import datetime


pattern = re.compile(r"^\d{1,} (\(.\) ){0,1}(?P<date>\d{4}-\d{2}-\d{2})")
ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')

def main(args=None):
	now = datetime.now()
	for line in sys.stdin:
		raw_line = ansi_escape.sub('', line)
		match = pattern.search(raw_line)
		if match:
			threshold = datetime.strptime(match['date'], '%Y-%m-%d')
			if threshold < now:
				print(line.strip())
		else:
			print(line.strip())
	return True


if __name__ == "__main__":
	status = not main(sys.argv)
	sys.exit(status)


