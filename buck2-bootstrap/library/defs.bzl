load("@prelude//rust:cargo_package.bzl", "cargo")

_STAGE0_RUSTC_FLAGS = [
    "--cfg=bootstrap",
    "--check-cfg=values(bootstrap)",
]

_ADDITIONAL_RUSTC_FLAGS = [
    "opt-level=3",
]

_RUSTC_FLAGS = select({
    "bootstrap//:stage0": _STAGE0_RUSTC_FLAGS + _ADDITIONAL_RUSTC_FLAGS,
    "bootstrap//:stage1": _ADDITIONAL_RUSTC_FLAGS,
    "bootstrap//:stage2": _ADDITIONAL_RUSTC_FLAGS,
})

def stdlib_rust_library(name, **kwargs):
    env = kwargs.get("env", {})
    rustc_flags = kwargs.get("rustc_flags", [])

    rustc_flags = rustc_flags + _RUSTC_FLAGS
    env["RUSTC_BOOTSTRAP"] = "1"

    kwargs["rustc_flags"] = rustc_flags

    cargo.rust_library(name, env = env, **kwargs)
