load("@prelude//rust:cargo_package.bzl", "cargo")

_STAGE0_RUSTC_FLAGS = [
    "--cfg=bootstrap",
    "--check-cfg=cfg(bootstrap)",
]

_EXTRA_RUSTC_FLAGS = [
    "-Copt-level=3",
]

_RUSTC_FLAGS = select({
    "bootstrap//constraints:use_beta": _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:use_stage0": _STAGE0_RUSTC_FLAGS + _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:use_stage1": _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:use_stage1p": _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:use_stage2": _EXTRA_RUSTC_FLAGS,
})

def stdlib_rust_library(name, **kwargs):
    env = kwargs.get("env", {})
    rustc_flags = kwargs.get("rustc_flags", [])

    rustc_flags = rustc_flags + _RUSTC_FLAGS
    env["RUSTC_BOOTSTRAP"] = "1"

    kwargs["rustc_flags"] = rustc_flags

    cargo.rust_library(name, env = env, **kwargs)
