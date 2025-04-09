load(
    "@bootstrap//:toolchain_types.bzl",
    "RustBootstrapToolchainInfo",
    "RustBootstrapInternalToolsInfo",
)

def _bootstrap_internal_tools_impl(ctx: AnalysisContext) -> list[Provider]:
    return [
        DefaultInfo(),
        RustBootstrapInternalToolsInfo(
            assemble_sysroot = ctx.attrs._assemble_sysroot[RunInfo],
        ),
    ]

bootstrap_internal_tools = rule(
    impl = _bootstrap_internal_tools_impl,
    attrs = {
        "_assemble_sysroot": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default = "bootstrap//tools:assemble_sysroot")),
    },
)
