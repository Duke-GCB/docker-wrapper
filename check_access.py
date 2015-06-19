#!/usr/bin/env python

import os
import sys

def parse_volume_spec(volume_spec):
  # Docker volumes may be "/src:dest:ro" or simply "/src"
  components = volume_spec.split(':')
  perm = 'w' # assume write perm if not specified
  src_path = components[0]
  # check if ro specified
  if components[-1] == 'ro':
    perm = 'r'
  return (src_path, perm)

def can_access(path, perm):
  mode = None
  if perm == 'r':
    mode = os.R_OK
  elif perm == 'w':
    mode = os.W_OK
  else:
    return False
  return os.access(path, mode)

if __name__ == '__main__':
  if len(sys.argv) < 2:
    exit
  volume_spec = sys.argv[1]
  path, perm = parse_volume_spec(volume_spec)
  uid = os.getuid()
  if can_access(path, perm):
    print "PASS: u {} has {} access to {}".format(uid, perm, path)
    exit(0)
  else:
    print "ERROR: u {} has no {} access to {}".format(uid, perm, path)
    exit(1)
