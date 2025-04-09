load(
    "@bootstrap//:toolchain_types.bzl",
    "RustBootstrapToolchainInfo",
    "RustBootstrapInternalToolsInfo",
)

def _rust_bootstrap_toolchain_impl(ctx: AnalysisContext) -> list[Provider]:
    return [
        DefaultInfo(),
        RustBootstrapToolchainInfo(
            internal_tools = ctx.attrs._internal_tools[RustBootstrapInternalToolsInfo],
        ),
    ]

rust_bootstrap_toolchain = rule(
    impl = _rust_bootstrap_toolchain_impl,
    attrs = {
        "_internal_tools": attrs.default_only(attrs.exec_dep(providers = [RustBootstrapInternalToolsInfo], default = "bootstrap//tools:internal_tools")),
    },
    is_toolchain_rule = True,
)
