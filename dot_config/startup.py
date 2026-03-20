# Ned's startup.py file, loaded into interactive python prompts.
# Has to work on both 2.x and 3.x

print("(.startup.py)")

import collections, datetime as dt, dis, itertools, json, math, os, pprint, re, sys, time
from pathlib import Path
print("(imported collections, datetime as dt, dis, itertools, json, math, os, re, sys, time, Path)")

pp = pprint.pprint

# A function for pasting code into the repl.
# Adapted from: https://mail.python.org/pipermail/python-list/2016-September/714384.html
def paste():
    import textwrap
    exec(textwrap.dedent(sys.stdin.read()), globals())
