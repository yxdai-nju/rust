load("@prelude//utils:lazy.bzl", "lazy")
load("@prelude//rust:cargo_package.bzl", "cargo")

_STAGE0_TO_STAGE1_RUSTC_FLAGS = [
    "--cfg=bootstrap",
    "--check-cfg=cfg(bootstrap)",
]

_EXTRA_RUSTC_FLAGS = [
    "--sysroot=$(location toolchains//utils:empty_sysroot)",
    "-Copt-level=3",
    "-Zforce-unstable-if-unmarked",
]

_RUSTC_FLAGS = select({
    "bootstrap//constraints:stage0": _STAGE0_TO_STAGE1_RUSTC_FLAGS + _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:stage1": _EXTRA_RUSTC_FLAGS,
    "bootstrap//constraints:stage2": _EXTRA_RUSTC_FLAGS,
})

def stdlib_rust_binary(name, **kwargs):
    cargo.rust_binary(name = name, **kwargs)

def stdlib_rust_library(name, **kwargs):
    rustc_flags = kwargs.pop("rustc_flags", [])
    env = kwargs.pop("env", {})

    rustc_flags = rustc_flags + _RUSTC_FLAGS
    env["RUSTC_BOOTSTRAP"] = "1"

    kwargs["rustc_flags"] = rustc_flags
    kwargs["env"] = env

    cargo.rust_library(name = name, **kwargs)

def add_configured_aliases(platform):
    targets = [
        "//library:core",
        "//library:std",
        # "//library:compiler_builtins",
        # "//library:alloc",
        # "//library:panic_unwind",
        # "//library:proc_macro",
    ]

    def _target_name_with_stage(target, platform):
        name = target.split(":")[-1]
        stage = platform.split("_")[-1]
        return name + "-" + stage

    [
        native.configured_alias(
            name = _target_name_with_stage(target, platform),
            actual = target,
            platform = platform,
            visibility = ["PUBLIC"],
        )
        for target in targets
    ]
