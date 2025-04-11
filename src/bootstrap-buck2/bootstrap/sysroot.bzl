load("@prelude//:paths.bzl", "paths")
load("@bootstrap//:sysroot_types.bzl", "SysrootInfo")
load("@bootstrap//:toolchain_types.bzl", "RustBootstrapToolchainInfo")

def _sysroot_from_http_archive_impl(ctx: AnalysisContext) -> list[Provider]:
    rbi_assemble_sysroot = ctx.attrs._assemble_sysroot[RunInfo]

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
        "_assemble_sysroot": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default = "bootstrap//tools:assemble_sysroot")),
    },
)
