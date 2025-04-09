load("@prelude//rust:rust_toolchain.bzl", "PanicRuntime", "RustToolchainInfo")

def rust_toolchain_from_sysroot_impl(ctx):
    sysroot_path = ctx.attrs.sysroot_path
    
    return [
        DefaultInfo(),
        RustToolchainInfo(
            clippy_driver = RunInfo(args = [sysroot_path + "/bin/clippy-driver"]),
            compiler = RunInfo(args = [sysroot_path + "/bin/rustc"]),
            default_edition = ctx.attrs.default_edition,
            panic_runtime = PanicRuntime("unwind"),
            rustc_binary_flags = ctx.attrs.rustc_binary_flags,
            rustc_flags = ctx.attrs.rustc_flags + ["--sysroot", sysroot_path],
            rustc_target_triple = ctx.attrs.rustc_target_triple,
            rustc_test_flags = ctx.attrs.rustc_test_flags,
            rustdoc = RunInfo(args = [sysroot_path + "/bin/rustdoc"]),
            rustdoc_flags = ctx.attrs.rustdoc_flags,
        ),
    ]

rust_toolchain_from_sysroot = rule(
    impl = rust_toolchain_from_sysroot_impl,
    attrs = {
        "sysroot_path": attrs.string(),
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
