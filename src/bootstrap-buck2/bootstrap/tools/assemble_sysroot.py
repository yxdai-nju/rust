#!/usr/bin/env python3

"""
Utility to create sysroot directory from artifacts

$ assemble_sysroot.py --dest=<sysroot_directory_to_create>
"""

import argparse
import os
import subprocess
import sys
from pathlib import Path
from typing import List


def main(argv: List[str]) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dest", type=str, required=True)
    args = parser.parse_args(argv[1:])

    env = os.environ.copy()
    # Create an empty directory from sysroot
    cmd = ["mkdir", "-p", args.dest]
    # TODO(yxdai-nju): place artifacts under sysroot

    return subprocess.call(cmd, env=env)


sys.exit(main(sys.argv))
