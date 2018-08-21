#!/usr/bin/env python3

import re

datestring = "2018-08-31"

print( re.match( "^\d{4}-\d{2}-\d{2}$", datestring) )