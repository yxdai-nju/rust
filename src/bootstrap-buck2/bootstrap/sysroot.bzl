load("@prelude//:paths.bzl", "paths")
load("@bootstrap//:sysroot_types.bzl", "SysrootInfo")
load("@bootstrap//:toolchain_types.bzl", "RustBootstrapToolchainInfo")

def _sysroot_from_http_archive_impl(ctx: AnalysisContext) -> list[Provider]:
    bootstrap_toolchain = ctx.attrs._rust_bootstrap_toolchain[RustBootstrapToolchainInfo]
    internal_tools = bootstrap_toolchain.internal_tools
    rbi_assemble_sysroot = internal_tools.assemble_sysroot

    outdir = ctx.actions.declare_output(ctx.attrs.name, dir = True)
    cmd = cmd_args([rbi_assemble_sysroot])
    if ctx.attrs.rust_std:
        cmd.add("--rust-std", ctx.attrs.rust_std[DefaultInfo].default_outputs[0])
    if ctx.attrs.rustc:
        cmd.add("--rustc", ctx.attrs.rustc[DefaultInfo].default_outputs[0])
    if ctx.attrs.cargo:
        cmd.add("--cargo", ctx.attrs.cargo[DefaultInfo].default_outputs[0])
    cmd.add("--dest", outdir.as_output())
    ctx.actions.run(cmd, category = "rbi_assemble_sysroot")

    return [
        DefaultInfo(),
        SysrootInfo(
            directory = DefaultInfo(default_output = outdir),
            clippy_driver_bin = RunInfo(args = outdir.project(paths.join("bin", "clippy-driver"))),
            rustc_bin = RunInfo(args = outdir.project(paths.join("bin", "rustc"))),
            rustdoc_bin = RunInfo(args = outdir.project(paths.join("bin", "rustdoc"))),
        )
    ]

sysroot_from_http_archive = rule(
    impl =_sysroot_from_http_archive_impl,
    attrs = {
        "rust_std": attrs.option(attrs.dep(providers = [DefaultInfo]), default = None),
        "rustc": attrs.option(attrs.dep(providers = [DefaultInfo]), default = None),
        "cargo": attrs.option(attrs.dep(providers = [DefaultInfo]), default = None),
        "_rust_bootstrap_toolchain": attrs.default_only(attrs.toolchain_dep(providers = [RustBootstrapToolchainInfo], default = "toolchains//:rust_bootstrap")),
    },
)
