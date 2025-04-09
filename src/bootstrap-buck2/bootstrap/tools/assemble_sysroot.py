#!/usr/bin/env python3

"""
This script creates a Rust sysroot directory by combining components from
separate Rust toolchain artifacts (rust-std, rustc, and cargo).

Usage:
    assemble_sysroot.py [--rust-std PATH] [--rustc PATH] [--cargo PATH] --dest SYSROOT_PATH

Arguments:
    --rust-std PATH         Path to the rust-std component directory
    --rustc PATH            Path to the rustc component directory
    --cargo PATH            Path to the cargo component directory
    --dest SYSROOT_PATH     Path to the sysroot directory to create (required)

Example:
    assemble_sysroot.py --rust-std ./rust-std-1.85.0 --rustc ./rustc-1.85.0 \
                        --cargo ./cargo-1.85.0 --dest ./my-sysroot
"""

import argparse
import os
import shutil
import sys
from pathlib import Path
from typing import List


def safe_copytree(src: Path, dst: Path, dirs_exist_ok: bool) -> None:
    """
    Copy a directory tree, but raise an error if any file would be overwritten.
    """
    # First check if any files would be overwritten
    if dst.exists():
        for src_file in src.glob('**/*'):
            if src_file.is_file():
                # Calculate the relative path from src to src_file
                rel_path = src_file.relative_to(src)
                # Construct the corresponding destination path
                dst_file = dst / rel_path

                if dst_file.exists():
                    raise FileExistsError(f"Destination file already exists: {dst_file}")

    # If we get here, no files will be overwritten, so proceed with copy
    shutil.copytree(src, dst, dirs_exist_ok=dirs_exist_ok)


def main(argv: List[str]) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rust-std", type=str)
    parser.add_argument("--rustc", type=str)
    parser.add_argument("--cargo", type=str)
    parser.add_argument("--dest", type=str, required=True)
    args = parser.parse_args(argv[1:])
    env = os.environ.copy()

    # Step 1: Create an empty sysroot directory
    outdir = Path(args.dest)
    try:
        outdir.mkdir(parents=True, exist_ok=True)
    except Exception as e:
        print(f"Error creating directory: {e}")
        return 1

    sysroot_bin_dir = outdir / "bin"
    sysroot_lib_dir = outdir / "lib"

    # Step 2: Copy rust-atd files to the sysroot
    if args.rust_std:
        try:
            # Copy standard library files '[sysroot]/lib/rustlib/*'
            safe_copytree(Path(args.rust_std) / "lib" / "rustlib", sysroot_lib_dir / "rustlib", dirs_exist_ok=True)
        except Exception as e:
            print(f"Error copying rust-std files: {e}")
            return 1

    # Step 3: Copy rustc files to the sysroot
    if args.rustc:
        try:
            # Copy rustc binaries '[sysroot]/bin/*'
            safe_copytree(Path(args.rustc) / "bin", sysroot_bin_dir, dirs_exist_ok=True)
            # Copy rustc libraries '[sysroot]/lib/*'
            safe_copytree(Path(args.rustc) / "lib", sysroot_lib_dir, dirs_exist_ok=True)
        except Exception as e:
            print(f"Error copying rustc files: {e}")
            return 1

    # Step 4: Copy cargo files to the sysroot
    if args.cargo:
        try:
            # Copy cargo binaries '[sysroot]/bin/*'
            safe_copytree(Path(args.cargo) / "bin", sysroot_bin_dir, dirs_exist_ok=True)
        except Exception as e:
            print(f"Error copying cargo files: {e}")
            return 1

    return 0


sys.exit(main(sys.argv))
