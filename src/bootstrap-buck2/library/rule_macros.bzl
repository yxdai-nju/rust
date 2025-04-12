load("@prelude//rust:cargo_package.bzl", "cargo")

_BETA_TO_STAGE0_RUSTC_FLAGS = [
    "--cfg=bootstrap",
    "--check-cfg=cfg(bootstrap)",
]

_EXTRA_RUSTC_FLAGS = [
    "-Copt-level=3",
]

_RUSTC_FLAGS = select({
    "bootstrap//constraints:beta": _BETA_TO_STAGE0_RUSTC_FLAGS + _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:stage0": _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:stage1": _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:stage1p": _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:stage2": _EXTRA_RUSTC_FLAGS,
})

def stdlib_rust_library(name, **kwargs):
    rustc_flags = kwargs.pop("rustc_flags", [])
    env = kwargs.pop("env", {})

    rustc_flags = rustc_flags + _RUSTC_FLAGS
    env["RUSTC_BOOTSTRAP"] = "1"

    kwargs["rustc_flags"] = rustc_flags
    kwargs["env"] = env

    cargo.rust_library(name = name, **kwargs)
