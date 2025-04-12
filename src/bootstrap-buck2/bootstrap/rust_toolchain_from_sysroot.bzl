load("@prelude//rust:rust_toolchain.bzl", "PanicRuntime", "RustToolchainInfo")
load("@bootstrap//:sysroot_types.bzl", "SysrootInfo")

def _rust_toolchain_from_sysroot_impl(ctx):
    sysroot = ctx.attrs.sysroot[SysrootInfo]

    return [
        DefaultInfo(),
        RustToolchainInfo(
            clippy_driver = sysroot.clippy_driver_bin,
            compiler = sysroot.rustc_bin,
            default_edition = ctx.attrs.default_edition,
            panic_runtime = PanicRuntime("unwind"),
            rustc_binary_flags = ctx.attrs.rustc_binary_flags,
            rustc_flags = ctx.attrs.rustc_flags,
            rustc_target_triple = ctx.attrs.rustc_target_triple,
            rustc_test_flags = ctx.attrs.rustc_test_flags,
            rustdoc = sysroot.rustdoc_bin,
            rustdoc_flags = ctx.attrs.rustdoc_flags,
            sysroot_path = sysroot.directory.default_outputs[0],
        ),
    ]

_rust_toolchain_from_sysroot_rule = rule(
    impl = _rust_toolchain_from_sysroot_impl,
    attrs = {
        "sysroot": attrs.dep(providers = [SysrootInfo]),
        "default_edition": attrs.option(attrs.string(), default = None),
        "rustc_binary_flags": attrs.list(attrs.string(), default = []),
        "rustc_flags": attrs.list(attrs.string(), default = []),
        # TODO(yxdai-nju): support customizing target triple
        "rustc_target_triple": attrs.string(default = "x86_64-unknown-linux-gnu"),
        "rustc_test_flags": attrs.list(attrs.string(), default = []),
        "rustdoc_flags": attrs.list(attrs.string(), default = []),
    },
    is_toolchain_rule = True,
)

def rust_toolchain_from_sysroot(name, **kwargs):
    exec_compatible_with = select({
        "bootstrap//constraints:beta": ["bootstrap//constraints:beta"],
        "bootstrap//constraints:stage0": ["bootstrap//constraints:stage0"],
        "bootstrap//constraints:stage1": ["bootstrap//constraints:stage1"],
        "bootstrap//constraints:stage1p": ["bootstrap//constraints:stage1p"],
        "bootstrap//constraints:stage2": ["bootstrap//constraints:stage2"],
    })
    _rust_toolchain_from_sysroot_rule(
        name = name,
        exec_compatible_with = exec_compatible_with,
        **kwargs,
    )
