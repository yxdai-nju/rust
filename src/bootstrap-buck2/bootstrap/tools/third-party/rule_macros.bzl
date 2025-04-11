load("@prelude//:prelude.bzl", "native")
load("@prelude//rust:cargo_package.bzl", "cargo")

_EXTRA_RUSTC_FLAGS = [
    "-Copt-level=3",
]

_RUSTC_FLAGS = select({
    "bootstrap//constraints:beta": _EXTRA_RUSTC_FLAGS,
})

def rbi_rust_binary(name, **kwargs):
    rustc_flags = kwargs.get("rustc_flags", [])

    rustc_flags = rustc_flags + _RUSTC_FLAGS
    kwargs["rustc_flags"] = rustc_flags

    cargo.rust_binary(name, **kwargs)

def rbi_rust_library(name, **kwargs):
    rustc_flags = kwargs.get("rustc_flags", [])

    rustc_flags = rustc_flags + _RUSTC_FLAGS
    kwargs["rustc_flags"] = rustc_flags

    cargo.rust_library(name, **kwargs)
